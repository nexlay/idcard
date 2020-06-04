import 'package:flutter/material.dart';
import 'package:idcard/screens/Wrapper.dart';
import 'package:idcard/service/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() {
  runApp(IdCard());
}

class IdCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthUser().user,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: 'FiraSans',
        ),
        home: Wrapper(),
      ),
    );
  }
}
