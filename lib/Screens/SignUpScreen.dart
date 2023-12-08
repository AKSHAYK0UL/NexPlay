import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_movies/Models/firebaseFUN.dart';
import 'package:nex_movies/Models/storeDeviceTokens.dart';
import 'package:nex_movies/main.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback _onClick;
  SignUpScreen(this._onClick);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  bool _eye = true;
  bool _eyec = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Future<void> onClicksignUP() async {
    final valid = _formkey.currentState!.validate();
    if (!valid) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await Provider.of<FirebaseFUN>(context, listen: false).signUp(
        _emailController.text,
        _passwordController.text,
      );
      navigatorkey.currentState!.pop();
      String? devicetoken = await FirebaseMessaging.instance.getToken();
      List<String> tokenlist =
          Provider.of<DeviceTokens>(navigatorkey.currentContext!, listen: false)
              .deviceToken;
      int index = tokenlist.indexWhere((element) => element == devicetoken);
      if (index == -1) {
        await Provider.of<DeviceTokens>(navigatorkey.currentContext!,
                listen: false)
            .storeToken(devicetoken);
      }
    } on FirebaseException catch (error) {
      navigatorkey.currentState!.pop();
      print(error.code.toString());
      if (error.code == 'email-already-in-use') {
        showError('This Email address is already in use.');
      } else if (error.code == 'weak-password') {
        showError('Password should be at least 6 characters long.');
      } else if (error.code == 'invalid-email') {
        showError('Invalid Email address.');
      }
    }
  }

  void showError(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Sign In error!',
            style: TextStyle(
              color: Colors.red,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            error,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close  ',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: _mediaQ.height * 0.400,
                      width: double.infinity,
                      child: Lottie.asset(
                        'assets/sign.json',
                        fit: BoxFit.fitHeight,
                        repeat: false,
                      ),
                    ),
                    Positioned(
                      top: _mediaQ.height * 0.345,
                      child: const Text(
                        'Let\'s create an account for you!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your email';
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    labelText: 'Email',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter the Password';
                    }
                    return null;
                  },
                  obscureText: _eye,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _eye = !_eye;
                        });
                      },
                      icon: Icon(
                        _eye ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    labelText: 'Password',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || _passwordController.text != value) {
                      return 'Confirm Password is incorrect.';
                    }
                    return null;
                  },
                  obscureText: _eyec,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _eyec = !_eyec;
                        });
                      },
                      icon: Icon(
                        _eye ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    labelText: 'Confirm Password',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  // height: 45,
                  height: _mediaQ.height * 0.063,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      await onClicksignUP();
                      // if (_passwordController.text ==
                      //     _confirmPasswordController.text) {
                      //   await onClicksignUP();
                      // }
                    },
                    icon: const Icon(Icons.person),
                    label: const Text('Sign Up'),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: GestureDetector(
                      onTap: () {
                        widget._onClick();
                      },
                      child: const Text(
                        'Already a member?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          decorationThickness: 2,
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
