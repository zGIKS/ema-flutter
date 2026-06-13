import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/core/theme/app_theme.dart';
import 'app/iam/application/internal/session_manager.dart';
import 'app/iam/interfaces/pages/verify/verify.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // If .env is missing, ignore or log it
  }
  await SessionManager.loadPersistedSession();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ema',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const VerifyScreen(),
    );
  }
}
