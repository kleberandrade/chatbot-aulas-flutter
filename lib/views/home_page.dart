import 'package:material_ui/material_ui.dart';

import '../domain/conversation.dart';
import '../domain/local_tutor.dart';
import '../widgets/chat_message_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.tutor = const LocalTutor()});
  final Tutor tutor;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Conversation _chat;
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _chat = Conversation(tutor: widget.tutor)..addListener(_changed);
  }

  void _changed() {
    if (!mounted) return;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send([String? suggestion]) async {
    final text = suggestion ?? _input.text;
    if (_chat.isSending ||
        _chat.error != null ||
        !Conversation.validText(text)) {
      return;
    }
    _input.clear();
    await _chat.send(text);
    if (mounted && _chat.error == null) {
      _focus.requestFocus();
    }
  }

  void _reset() {
    _chat.reset();
    _input.clear();
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _chat.removeListener(_changed);
    _chat.dispose();
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONVERSA / LABORATÓRIO 01',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  MediaQuery.sizeOf(context).width < 600
                      ? 'Conversa'
                      : 'Uma pergunta. Uma descoberta.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                if (MediaQuery.sizeOf(context).width >= 600)
                  const Text(
                    'Explore como um chatbot reconhece intenções e encontra informações.',
                  ),
                const SizedBox(height: 20),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (constraints.maxWidth >= 900) ...[
                          SizedBox(width: 240, child: _guide()),
                          const SizedBox(width: 24),
                        ],
                        Expanded(child: _conversation()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _guide() => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.forum_outlined, size: 40, color: Color(0xFFA33F17)),
        const SizedBox(height: 20),
        const Text(
          'Aprenda conversando',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const Text(
          '01  Escreva uma pergunta\n02  Observe a intent\n03  Descubra as entidades',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(),
        ),
        const Text(
          'Regras locais, resultados visíveis.',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sem conta, sem credenciais e sem nuvem. As respostas são exemplos didáticos definidos no código.',
        ),
        const SizedBox(height: 20),
        const Text(
          'E o Dialogflow?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'A aula explica intents e entidades e o caminho de uma integração segura pelo seu servidor.',
        ),
      ],
    ),
  );

  Widget _conversation() => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFFFFFDF9),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFDED7CD)),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (MediaQuery.sizeOf(context).width >= 600)
                const CircleAvatar(
                  backgroundColor: Color(0xFFF7DDCB),
                  child: Icon(Icons.school_outlined, color: Color(0xFF7F3016)),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tutor local',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      MediaQuery.textScalerOf(context).scale(1) > 1.5
                          ? 'Local • sem nuvem'
                          : 'Demonstração local • sem nuvem',
                      style: TextStyle(fontSize: 12, color: Color(0xFF52594C)),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _reset,
                tooltip: 'Reiniciar conversa',
                icon: const Icon(Icons.restart_alt),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.all(16),
            children: [
              if (_chat.messages.isEmpty) _welcome(),
              for (final message in _chat.messages)
                ChatMessageListItem(
                  key: ValueKey(message.id),
                  message: message,
                ),
              if (_chat.isSending)
                Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Tutor está respondendo…'),
                  ),
                ),
              if (_chat.error case final String error)
                Semantics(
                  liveRegion: true,
                  child: Card(
                    color: const Color(0xFFFFE9DE),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(error),
                          TextButton.icon(
                            onPressed: _chat.retry,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        _composer(),
      ],
    ),
  );

  Widget _welcome() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vamos conversar?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sou um tutor de demonstração. Escolha um tema ou escreva sua pergunta.',
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final text in [
              'Quero aprender Flutter',
              'O que é uma intent?',
              'O que é uma entidade?',
            ])
              ActionChip(label: Text(text), onPressed: () => _send(text)),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Não envie dados pessoais. A conversa fica apenas na memória desta sessão.',
          style: TextStyle(fontSize: 12, color: Color(0xFF5D605F)),
        ),
      ],
    ),
  );

  Widget _composer() => Padding(
    padding: const EdgeInsets.all(12),
    child: ValueListenableBuilder(
      valueListenable: _input,
      builder: (context, value, child) {
        final count = value.text.trim().runes.length;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _input,
                focusNode: _focus,
                enabled: !_chat.isSending && _chat.error == null,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  labelText: 'Sua mensagem',
                  hintText: 'Pergunte ao tutor…',
                  counterText: '$count / 500',
                  errorText: count > 500
                      ? 'Use até 500 caracteres Unicode.'
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: IconButton.filled(
                onPressed:
                    !_chat.isSending &&
                        _chat.error == null &&
                        Conversation.validText(value.text)
                    ? _send
                    : null,
                tooltip: 'Enviar mensagem',
                icon: const Icon(Icons.arrow_upward),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
            ),
          ],
        );
      },
    ),
  );
}
