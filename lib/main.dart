import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'login_screen.dart.dart';
import 'register_screen.dart';
import 'forgotpasswordscreen.dart';
import 'resetpasswordscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth Flow',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        '/reset': (context) => const ResetPasswordScreen(),
         '/diary': (context) => const HomeScreen(),
      },
    );
  }
}
