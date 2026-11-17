import 'dart:async';

import 'package:chatbot/main.dart';
import 'package:chatbot/domain/conversation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('send by keyboard, display intent/entity and reset', (
    tester,
  ) async {
    await tester.pumpWidget(const TutorApp());
    expect(find.text('Demonstração local • sem nuvem'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Quero aprender Flutter');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
    expect(find.text('intent: course • course: Flutter'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w is SelectableText && w.data == 'Quero aprender Flutter',
      ),
      findsOneWidget,
    );
    expect(find.text('Você'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    await tester.tap(find.byTooltip('Reiniciar conversa'));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w is SelectableText && w.data == 'Quero aprender Flutter',
      ),
      findsNothing,
    );
    expect(find.text('Vamos conversar?'), findsOneWidget);
  });
  testWidgets('blank and over-limit messages cannot be submitted', (
    tester,
  ) async {
    await tester.pumpWidget(const TutorApp());
    await tester.enterText(find.byType(TextField), '   ');
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (w) => w is IconButton && w.tooltip == 'Enviar mensagem',
            ),
          )
          .onPressed,
      isNull,
    );
    await tester.enterText(find.byType(TextField), 'x' * 501);
    await tester.pump();
    expect(find.text('Use até 500 caracteres Unicode.'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
    expect(find.text('Você'), findsNothing);
  });
  testWidgets('pending, failure, retry and disposal are safe', (tester) async {
    final tutor = PendingTutor();
    await tester.pumpWidget(TutorApp(tutor: tutor));
    await tester.enterText(find.byType(TextField), 'oi');
    await tester.pump();
    await tester.tap(find.byTooltip('Enviar mensagem'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Tutor está respondendo…'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, false);
    tutor.pending.completeError(StateError('network'));
    await tester.pumpAndSettle();
    expect(find.text('Tentar novamente'), findsOneWidget);
    tutor.pending = Completer<BotReply>();
    await tester.tap(find.text('Tentar novamente'));
    await tester.pump();
    expect(
      find.byWidgetPredicate((w) => w is SelectableText && w.data == 'oi'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    tutor.pending.complete(const BotReply('late', 'greeting'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('narrow viewport and large text stay usable', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: const HomePage(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'O que é uma entidade?');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

class PendingTutor implements Tutor {
  Completer<BotReply> pending = Completer<BotReply>();
  @override
  Future<BotReply> reply(String text) => pending.future;
}
