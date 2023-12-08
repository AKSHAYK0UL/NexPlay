import 'package:flutter/material.dart';
import 'package:nex_movies/Screens/LoginScreen.dart';
import 'package:nex_movies/Screens/SignUpScreen.dart';

class SignINorUP extends StatefulWidget {
  const SignINorUP({super.key});

  @override
  State<SignINorUP> createState() => _SignINorUPState();
}

class _SignINorUPState extends State<SignINorUP> {
  bool _authOption = true;
  void toggle() {
    setState(() {
      _authOption = !_authOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _authOption ? LoginScreen(toggle) : SignUpScreen(toggle);
  }
}
