import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_movies/Screens/bottomNavScreen.dart';

class VerifyUSERscreen extends StatefulWidget {
  final User? snapshotData;
  VerifyUSERscreen(this.snapshotData);

  @override
  State<VerifyUSERscreen> createState() => _VerifyUSERscreenState();
}

class _VerifyUSERscreenState extends State<VerifyUSERscreen> {
  Timer? timer;
  Timer? showtimer;
  int totaltime = 90;
  bool _verifyUserEmail = false;
  void notDoneOnTime() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              'Verification not completed',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Verificaation is not done on time try again.',
              style: TextStyle(
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
        });
  }

  void startTimer() {
    showtimer = Timer.periodic(
      const Duration(seconds: 1),
      (timert) {
        if (totaltime == 0 && !_verifyUserEmail) {
          setState(() {
            timert.cancel();

            Future.delayed(
              Duration.zero,
              () {
                notDoneOnTime();
              },
            ).then((value) => widget.snapshotData!.delete());
          });
        } else {
          setState(() {
            totaltime--;
          });
        }
      },
    );
  }

  Future<void> sendEmailVerfication() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
    } on FirebaseAuthException catch (_) {
      showError();
    }
  }

  void showError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Verification error!',
            style: TextStyle(
              color: Colors.red,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Something went wrong',
            style: TextStyle(
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

  Future<void> checkEmailStatus() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(
      () {
        _verifyUserEmail = FirebaseAuth.instance.currentUser!.emailVerified;
      },
    );
    if (_verifyUserEmail) {
      timer!.cancel();
    }
  }

  @override
  void initState() {
    _verifyUserEmail = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!_verifyUserEmail) {
      sendEmailVerfication();
      startTimer();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) {
          checkEmailStatus();
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _verifyUserEmail
        ? BottomNavScreen()
        : Scaffold(
            body: Container(
              margin: const EdgeInsets.only(top: 150),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/emailverify.json',
                    fit: BoxFit.fitWidth,
                    repeat: false,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Check your Email to verify it\'s you.\nRemaining time ${totaltime.toString()} sec.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    width: double.infinity,
                    // height: 45,
                    height: MediaQuery.of(context).size.height * 0.063,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        timer!.cancel();
                        widget.snapshotData!.delete();
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel verification'),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
