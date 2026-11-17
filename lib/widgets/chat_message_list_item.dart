import 'package:material_ui/material_ui.dart';

import '../domain/conversation.dart';

String messageDate(DateTime value) {
  final local = value.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year} • ${two(local.hour)}:${two(local.minute)}';
}

class ChatMessageListItem extends StatelessWidget {
  const ChatMessageListItem({super.key, required this.message});
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    final sent = message.author == Author.you;
    final author = sent ? 'Você' : 'Tutor local';
    final metadata = [
      if (message.intent != null) 'intent: ${message.intent}',
      for (final entry in message.entities.entries)
        '${entry.key}: ${entry.value}',
    ].join(' • ');
    return Align(
      alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Semantics(
            container: true,
            label:
                '$author, ${messageDate(message.time)}. ${message.text}. $metadata',
            excludeSemantics: true,
            liveRegion: !sent,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: sent ? const Color(0xFF273C4B) : const Color(0xFFF1EAE0),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(sent ? 18 : 4),
                  bottomRight: Radius.circular(sent ? 4 : 18),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: sent ? Colors.white : const Color(0xFF263342),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(message.text),
                      if (metadata.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            metadata,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        messageDate(message.time),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
