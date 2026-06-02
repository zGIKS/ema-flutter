import 'package:ema/contexts/identification/interfaces/pages/identification_shell.screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Allow running without .env (tests / fresh clone); fallback is handled in UI.
  }
  runApp(const EmaApp());
}

class EmaApp extends StatelessWidget {
  const EmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const IdentificationShellScreen(),
    );
  }
}
