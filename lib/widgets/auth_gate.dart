import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import '../main.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInScreen(
            providerConfigs: [
              GoogleProviderConfiguration(
                clientId:
                    '315374225316-u5ppm0f2vnchdbs10h6tbfh4hbq2kqsu.apps.googleusercontent.com',
              )
            ],
          );
        }
        return const MyHomePage();
      },
    );
  }
}
