import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:idcard/screens/home.dart';

class FlushBar {
  void flushBar(
    BuildContext context,
    String messageText,
    String buttonTitle,
    Color color,
    Color textColor,
    bool flag,
  ) {
    Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(20),
      borderRadius: 8.0,
      backgroundColor: color,
      mainButton: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            const Radius.circular(20.0),
          ),
        ),
        onPressed: () {
          if (flag) {
            Navigator.pop(context);
            return;
          } else if (flag == false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IdCardViewer(),
              ),
            );
          }
          ;
        },
        child: Text(
          buttonTitle,
          style: TextStyle(color: textColor, fontSize: 16.0),
        ),
      ),
      messageText: Text(
        messageText,
        style: TextStyle(color: textColor, fontSize: 14.0),
      ),
      duration: const Duration(seconds: 3),
    )..show(context);
  }
}
