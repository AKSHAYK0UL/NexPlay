import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_movies/Screens/VerifyUSERscreen.dart';
import 'package:nex_movies/Widgets/SignINorUP.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final delSnapshotdata = snapshot.data;
          if (snapshot.hasData) {
            return VerifyUSERscreen(delSnapshotdata);
          } else {
            return const SignINorUP();
          }
        },
      ),
    );
  }
}
