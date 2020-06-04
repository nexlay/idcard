import 'package:flutter/material.dart';
import 'package:idcard/screens/authenticate/register.dart';
import 'package:idcard/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthenticateState();
  }
}

class _AuthenticateState extends State<Authenticate> {
  // A toggle to show Register or Sing in screen
  bool toggle = true;

  void showScreen() {
    setState(() {
      toggle = !toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (toggle) {
      return SignIn(
        showScreen: showScreen,
      );
    } else
      return Register(
        showScreen: showScreen,
      );
  }
}
