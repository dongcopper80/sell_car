import 'package:flutter/material.dart';
import 'core/api_client.dart';
import 'core/session.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Session.init();
  ApiClient.init(baseUrl: const String.fromEnvironment('API_BASE', defaultValue: 'http://10.0.2.2:3000/api/v1'));
  runApp(const OtoChinhChuApp());
}

class OtoChinhChuApp extends StatelessWidget {
  const OtoChinhChuApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF176B4D); // xanh prototype
    return MaterialApp(
      title: 'OtoChinhChu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF5F8F6),
        fontFamily: 'Roboto',
      ),
      home: const SessionGate(),
    );
  }
}

class SessionGate extends StatelessWidget {
  const SessionGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: Session.tokenStream,
      initialData: Session.token,
      builder: (context, snap) {
        final token = snap.data;
        if (token == null || token.isEmpty) return const LoginScreen();
        return const HomeScreen();
      },
    );
  }
}
