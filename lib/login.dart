import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _handleSignIn(BuildContext context) async {
    await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Kakima\'s Evil Hunter Tycoon Utilities'),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () => _handleSignIn(context),
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
