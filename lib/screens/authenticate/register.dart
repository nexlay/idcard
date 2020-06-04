import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idcard/custom/flushbar.dart';
import 'package:idcard/custom/loading.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/service/auth.dart';

class Register extends StatefulWidget {
  final Function showScreen;
  Register({this.showScreen});
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<Register> {
  final AuthUser _auth = AuthUser();
  final FlushBar _flushBar = FlushBar();

  //Key to indetify our Form
  final _formKey = GlobalKey<FormState>();

  //Text Filed state
  String email = '';
  String password = '';
  //Show loading widget or not. By default not
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          const Text(
                            'Sign up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 43.0,
                                fontFamily: 'FredokaOne'),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal[200]),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            validator: (val) => val.length < 6
                                ? 'Enter minimum 6 chars long password '
                                : null,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal[200]),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          RaisedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);

                                _flushBar.flushBar(
                                    context,
                                    'Verification email sent successfully',
                                    'Hide',
                                    Colors.teal[300],
                                    Colors.white,
                                    true);

                                await _auth.register(email, password);

                                // setState(() => loading = false);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            icon: Icon(
                              SociaIcons.user,
                              color: Colors.teal,
                              size: 18.0,
                            ),
                            label: const Text(
                              'Sing up',
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'or ',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'FredokaOne',
                                fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          RaisedButton.icon(
                            color: Colors.teal,
                            elevation: 0.0,
                            onPressed: () {
                              widget.showScreen();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            icon: Icon(
                              SociaIcons.login,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            label: const Text(
                              'Sing in',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
