import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idcard/screens/home.dart';
import 'package:idcard/service/auth.dart';

class HelloPage extends StatelessWidget {
  final AuthUser _auth = AuthUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.tealAccent,
              Colors.teal[700],
              Colors.teal[700],
              Colors.teal[400],
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  softWrap: true,
                  text: TextSpan(
                    text: 'Hello, dear User!',
                    style: TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: 36.0,
                        color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'Welcome ',
                        style: TextStyle(color: Colors.black, fontSize: 28.0),
                      ),
                      TextSpan(
                        text: 'to the ID Card',
                        style: TextStyle(color: Colors.black, fontSize: 28.0),
                      ),
                      TextSpan(
                        text: ' Have fun!',
                        style: TextStyle(color: Colors.white, fontSize: 36.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 18.0,
                          ),
                          Text(
                            'Sing out',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontFamily: 'FredokaOne'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IdCardViewer(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontFamily: 'FredokaOne'),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 18.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
