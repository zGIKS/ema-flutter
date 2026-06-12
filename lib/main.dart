import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/iam/interfaces/pages/sign_in/sign_in.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // If .env is missing, ignore or log it
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const scaffoldBackgroundColor = Color(0xFFF8F9FC);
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      canvasColor: scaffoldBackgroundColor,
    );

    return MaterialApp(
      title: 'Ema',
      debugShowCheckedModeBanner: false,
      theme: theme,
      builder: (context, child) {
        return ColoredBox(
          color: scaffoldBackgroundColor,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const SignInScreen(),
    );
  }
}
