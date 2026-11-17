import 'dart:async';

import 'package:chatbot/domain/conversation.dart';
import 'package:chatbot/domain/local_tutor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local rules identify intents, entities and honest fallback', () async {
    const tutor = LocalTutor();
    expect((await tutor.reply('Olá!')).intent, 'greeting');
    final answer = await tutor.reply('Quero aprender flutter');
    expect(answer.intent, 'course');
    expect(answer.entities, {'course': 'Flutter'});
    expect(answer.text, contains('Flutter'));
    expect((await tutor.reply('quantos planetas existem?')).intent, 'fallback');
    expect((await tutor.reply('o que é uma intenção?')).intent, 'intent');
  });
  test('teaching topics stay explicit and local', () async {
    const tutor = LocalTutor();
    expect((await tutor.reply('O que é uma entidade?')).intent, 'entity');
    expect((await tutor.reply('Quero Dart')).entities, {'course': 'Dart'});
    expect((await tutor.reply('Dialogflow')).intent, 'integration');
    expect((await tutor.reply('segurança')).text, contains('Nunca inclua'));
    expect((await tutor.reply('obrigada')).intent, 'thanks');
    expect((await tutor.reply('ajuda')).intent, 'help');
    expect((await tutor.reply('coisa')).intent, 'fallback');
  });
  test(
    'reject empty and oversized input, trim and keep ordered timestamps',
    () async {
      final chat = Conversation(
        tutor: const LocalTutor(),
        clock: () => DateTime(2026, 11, 17, 10),
      );
      expect(await chat.send('   \n'), false);
      expect(await chat.send('x' * 501), false);
      expect(chat.messages, isEmpty);
      expect(await chat.send('  oi  '), true);
      expect(chat.messages.map((m) => m.text).first, 'oi');
      expect(chat.messages.map((m) => m.author), [Author.you, Author.tutor]);
      expect(chat.messages.first.time, DateTime(2026, 11, 17, 10));
      expect(chat.messages.map((m) => m.id).toSet().length, 2);
      expect(() => chat.messages.clear(), throwsUnsupportedError);
      chat.dispose();
    },
  );
  test('500 Unicode code points are allowed, including emoji', () async {
    final chat = Conversation(tutor: const LocalTutor());
    expect(await chat.send('😀' * 500), true);
    expect(await chat.send('😀' * 501), false);
    chat.dispose();
  });
  test('one pending turn, retry without duplicate user message', () async {
    final tutor = ControlledTutor();
    final chat = Conversation(tutor: tutor);
    final first = chat.send('oi');
    expect(chat.isSending, true);
    expect(await chat.send('outra'), false);
    tutor.pending.completeError(StateError('private detail'));
    await first;
    expect(chat.error, isNotNull);
    expect(chat.error, isNot(contains('private detail')));
    expect(await chat.send('nova'), false);
    tutor.pending = Completer<BotReply>();
    final retry = chat.retry();
    expect(chat.messages.length, 1);
    tutor.pending.complete(const BotReply('Olá', 'greeting'));
    await retry;
    expect(chat.messages.length, 2);
    expect(chat.error, isNull);
    expect(chat.isSending, false);
    chat.dispose();
  });
  test('reset discards late responses and permits a new turn', () async {
    final tutor = ControlledTutor();
    final chat = Conversation(tutor: tutor);
    final old = chat.send('old');
    final oldPending = tutor.pending;
    chat.reset();
    tutor.pending = Completer<BotReply>();
    final current = chat.send('new');
    oldPending.complete(const BotReply('stale', 'fallback'));
    await old;
    expect(chat.isSending, true);
    expect(chat.messages.map((m) => m.text), ['new']);
    tutor.pending.complete(const BotReply('fresh', 'fallback'));
    await current;
    expect(chat.messages.last.text, 'fresh');
    chat.dispose();
  });
  test(
    'dispose ignores completion; timeout and empty replies are recoverable',
    () async {
      final tutor = ControlledTutor();
      final chat = Conversation(tutor: tutor);
      final pending = chat.send('oi');
      chat.dispose();
      tutor.pending.complete(const BotReply('late', 'fallback'));
      await pending;
      expect(chat.messages.length, 1);
      final timeout = Conversation(
        tutor: ControlledTutor(),
        timeout: Duration.zero,
      );
      await timeout.send('oi');
      expect(timeout.error, isNotNull);
      expect(timeout.isSending, false);
      timeout.dispose();
      final empty = Conversation(tutor: EmptyTutor());
      await empty.send('oi');
      expect(empty.error, isNotNull);
      empty.reset();
      expect(empty.error, isNull);
      empty.dispose();
    },
  );
}

class ControlledTutor implements Tutor {
  Completer<BotReply> pending = Completer<BotReply>();
  @override
  Future<BotReply> reply(String text) => pending.future;
}

class EmptyTutor implements Tutor {
  @override
  Future<BotReply> reply(String text) async => const BotReply('  ', 'fallback');
}
