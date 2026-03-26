import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:verleihapp/pages/login/recover_password.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    // On web, inspect URL to see if this is a recovery intent
    if (kIsWeb) {
      final uri = Uri.base;
      final isRecovery = uri.queryParameters['type'] == 'recovery';
      final hasCode = uri.queryParameters.containsKey('code');
      
      if (isRecovery || hasCode) {
        Future.microtask(() {
          if (!mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RecoverPasswordPage(email: '', code: '')),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


