import 'package:flutter/material.dart';
import 'package:idcard/models/user.dart';
import 'package:idcard/screens/authenticate/authenticate.dart';
import 'package:idcard/welcome_screens/hello_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return HelloPage();
    }
  }
}
