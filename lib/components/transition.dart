import 'package:block/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:block/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

AuthMethods authMethods = new AuthMethods();

class Transition extends StatefulWidget {
  @override
  _TransitionState createState() => _TransitionState();
}

class _TransitionState extends State<Transition> {
  @override
  void initState() {
    super.initState();
    googleLogin();
  }

  void googleLogin() async {
    await authMethods
        .handleSignIn()
        .then(
          (FirebaseUser user) => print(user),
        )
        .catchError((e) => print(e));
    if (await authMethods.stat == true) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitRotatingCircle(
          color: Colors.orange[800],
          size: 100.0,
        ),
      ),
    );
  }
}
