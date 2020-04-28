import 'package:flutter/material.dart';
import 'package:idcard/home.dart';

void main() {
  runApp(IdCard());
}

class IdCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'FiraSans',
      ),
      home: IdCreator(),
    );
  }
}
