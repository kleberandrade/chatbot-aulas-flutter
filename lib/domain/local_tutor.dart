/// The integration boundary. A remote implementation must call your own server.
abstract interface class Tutor {
  Future<BotReply> reply(String text);
}

class BotReply {
  const BotReply(this.text, this.intent, [this.entities = const {}]);
  final String text;
  final String intent;
  final Map<String, String> entities;
}

/// Deterministic teaching rules. This does not call or emulate Dialogflow NLU.
class LocalTutor implements Tutor {
  const LocalTutor();

  @override
  Future<BotReply> reply(String text) async => classify(text);

  BotReply classify(String text) {
    final query = text.toLowerCase();
    if (RegExp(
      r'(^|\s)(oi|ola|olá|bom dia|boa tarde|boa noite)(?=\s|[!?. ,]|$)',
    ).hasMatch(query)) {
      return const BotReply(
        'Olá! Sou o tutor local. Pergunte sobre Flutter, intents ou entidades.',
        'greeting',
      );
    }
    if (query.contains('intent') || query.contains('intenç')) {
      return const BotReply(
        'Uma intent representa o objetivo de uma mensagem. Exemplo: consultar um curso. '
            'Aqui usamos regras explícitas; no Dialogflow você fornece frases de treinamento.',
        'intent',
      );
    }
    if (query.contains('entidad') || query.contains('entit')) {
      return const BotReply(
        'Uma entidade identifica um valor na frase. Em “quero aprender Flutter”, '
            'o curso é Flutter. Experimente essa frase!',
        'entity',
      );
    }
    if (query.contains('flutter') || RegExp(r'\bdart\b').hasMatch(query)) {
      final course = query.contains('flutter') ? 'Flutter' : 'Dart';
      return BotReply(
        '$course é um dos temas desta aula. Comece pelo README do projeto e execute os testes. '
            'Esta resposta veio de uma regra local, sem consulta externa.',
        'course',
        Map.unmodifiable({'course': course}),
      );
    }
    if (query.contains('dialogflow') || query.contains('seguran')) {
      return const BotReply(
        'Uma integração real passa pelo seu servidor autenticado, que chama o Dialogflow. '
            'Nunca inclua uma chave de serviço no app. Este demonstrador não usa a nuvem.',
        'integration',
      );
    }
    if (query.contains('obrigad')) {
      return const BotReply(
        'De nada! Continue explorando e testando.',
        'thanks',
      );
    }
    if (query.contains('ajuda')) {
      return const BotReply(
        'Experimente: “O que é uma intent?”, “O que é uma entidade?” ou '
            '“Quero aprender Flutter”. As regras são limitadas e estão no código.',
        'help',
      );
    }
    return const BotReply(
      'Ainda não tenho uma regra para essa pergunta. Tente perguntar sobre '
          'Flutter, intents, entidades ou Dialogflow.',
      'fallback',
    );
  }
}
