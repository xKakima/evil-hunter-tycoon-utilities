import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _handleSignIn() async {
    final response = await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
  if (kDebugMode) {
    print(response);
  }
    // if (response != null) {
    //   // Handle error
    // } else {
    //   // Handle success
    // }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _handleSignIn,
      child: const Text('Sign in with Google'),
    );
  }
}