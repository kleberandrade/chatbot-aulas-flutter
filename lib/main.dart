import 'package:material_ui/material_ui.dart';

import 'domain/local_tutor.dart';
import 'views/home_page.dart';
export 'views/home_page.dart' show HomePage;

void main() => runApp(const TutorApp());

class TutorApp extends StatelessWidget {
  const TutorApp({super.key, this.tutor = const LocalTutor()});
  final Tutor tutor;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Conversa • Laboratório de chatbot',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA33F17)),
      scaffoldBackgroundColor: const Color(0xFFF7F4EF),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xFF202D3D),
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    home: HomePage(tutor: tutor),
  );
}
