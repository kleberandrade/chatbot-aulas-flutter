import 'dart:async';

import 'package:flutter/foundation.dart';

import 'local_tutor.dart';
export 'local_tutor.dart' show BotReply, Tutor;

enum Author { you, tutor }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.author,
    required this.time,
    this.intent,
    this.entities = const {},
  });
  final int id;
  final String text;
  final Author author;
  final DateTime time;
  final String? intent;
  final Map<String, String> entities;
}

/// One writer, one in-flight turn. Generation invalidates reset/disposed work.
class Conversation extends ChangeNotifier {
  Conversation({
    required this.tutor,
    DateTime Function()? clock,
    this.timeout = const Duration(seconds: 15),
  }) : _clock = clock ?? DateTime.now;
  static const maxCodePoints = 500;
  final Tutor tutor;
  final DateTime Function() _clock;
  final Duration timeout;
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool _isSending = false;
  bool get isSending => _isSending;
  String? _error;
  String? get error => _error;
  int _generation = 0;
  int _nextId = 0;
  bool _disposed = false;

  static bool validText(String text) =>
      text.trim().isNotEmpty && text.trim().runes.length <= maxCodePoints;

  Future<bool> send(String text) async {
    if (_disposed || _isSending || _error != null || !validText(text)) {
      return false;
    }
    final clean = text.trim();
    _messages.add(
      ChatMessage(
        id: _nextId++,
        text: clean,
        author: Author.you,
        time: _clock(),
      ),
    );
    await _respond(clean);
    return true;
  }

  Future<void> retry() async {
    if (_disposed || _isSending || _error == null) return;
    await _respond(_messages.last.text);
  }

  Future<void> _respond(String text) async {
    final generation = _generation;
    _isSending = true;
    _error = null;
    notifyListeners();
    try {
      final answer = await tutor.reply(text).timeout(timeout);
      if (!_current(generation)) return;
      if (answer.text.trim().isEmpty) {
        throw const FormatException('Empty reply');
      }
      _messages.add(
        ChatMessage(
          id: _nextId++,
          text: answer.text.trim(),
          author: Author.tutor,
          time: _clock(),
          intent: answer.intent,
          entities: Map.unmodifiable(answer.entities),
        ),
      );
    } catch (_) {
      if (!_current(generation)) return;
      _error =
          'Não foi possível responder. Tente novamente ou reinicie a conversa.';
    } finally {
      if (_current(generation)) {
        _isSending = false;
        notifyListeners();
      }
    }
  }

  bool _current(int generation) => !_disposed && generation == _generation;

  void reset() {
    if (_disposed) return;
    _generation++;
    _messages.clear();
    _isSending = false;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
