import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:idcard/custom/flushbar.dart';
import 'package:idcard/custom/loading.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/user.dart';
import 'package:idcard/user_image/empty_image.dart';
import 'package:idcard/user_image/not_empty_image.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart';

class UserDataCreator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatorState();
  }
}

class _CreatorState extends State<UserDataCreator> {
  //A default color of the screen
  Color defaultColor = Colors.teal;

  final FlushBar _flushBar = FlushBar();

  //Key to indetify our Form
  final _formKey = GlobalKey<FormState>();

  //Check if user input some text in TextFields
  bool _visibleName = false;
  bool _visibleJob = false;
  bool _visiblePhone = false;
  bool _visibleMail = false;
  bool _visibleLocation = false;
  bool _visibleLink = false;
  bool _visibleTwitter = false;
  bool _visibleFacebook = false;
  bool _visibleInstagram = false;
  bool _visibleGit = false;

  //To retrieve the text a user has entered into a text field using TextEditingController
  final jobController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final mailController = TextEditingController();
  final linkController = TextEditingController();
  final locationController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final githubController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_addListener();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // It also removes the _printLatestValue listener.
    jobController.dispose();
    nameController.dispose();
    phoneController.dispose();
    mailController.dispose();
    linkController.dispose();
    locationController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    githubController.dispose();
    super.dispose();
  }

  //Set data from database to particular TextFields when User want to Edit data
  _setUserToController(UserData user) {
    nameController.text = user.name;
    jobController.text = user.job;
    phoneController.text = user.phone;
    mailController.text = user.mail;
    linkController.text = user.link;
    locationController.text = user.location;
    twitterController.text = user.twitter;
    facebookController.text = user.facebook;
    instagramController.text = user.instagram;
    githubController.text = user.github;
  }

  //Clear all fields
  _clearController() {
    nameController.clear();
    jobController.clear();
    phoneController.clear();
    mailController.clear();
    linkController.clear();
    locationController.clear();
    twitterController.clear();
    facebookController.clear();
    instagramController.clear();
    githubController.clear();
  }

  //Check if lengths of text in TextFields is > 0
  /*_addListener() {
    nameController.addListener(() {
      if (nameController.text.length > 0) {
        setState(() {
          _visibleName = true;
        });
      } else
        setState(() {
          _visibleName = false;
        });
    });
    jobController.addListener(() {
      if (jobController.text.length > 0) {
        setState(() {
          _visibleJob = true;
        });
      } else
        setState(() {
          _visibleJob = false;
        });
    });
    phoneController.addListener(() {
      if (phoneController.text.length > 0) {
        setState(() {
          _visiblePhone = true;
        });
      } else
        setState(() {
          _visiblePhone = false;
        });
    });
    mailController.addListener(() {
      if (mailController.text.length > 0) {
        setState(() {
          _visibleMail = true;
        });
      } else
        setState(() {
          _visibleMail = false;
        });
    });
    linkController.addListener(() {
      if (linkController.text.length > 0) {
        setState(() {
          _visibleLink = true;
        });
      } else
        setState(() {
          _visibleLink = false;
        });
    });
    locationController.addListener(() {
      if (locationController.text.length > 0) {
        setState(() {
          _visibleLocation = true;
        });
      } else
        setState(() {
          _visibleLocation = false;
        });
    });
    twitterController.addListener(() {
      if (twitterController.text.length > 0) {
        setState(() {
          _visibleTwitter = true;
        });
      } else
        setState(() {
          _visibleTwitter = false;
        });
    });
    facebookController.addListener(() {
      if (facebookController.text.length > 0) {
        setState(() {
          _visibleFacebook = true;
        });
      } else
        setState(() {
          _visibleFacebook = false;
        });
    });
    instagramController.addListener(() {
      if (instagramController.text.length > 0) {
        setState(() {
          _visibleInstagram = true;
        });
      } else
        setState(() {
          _visibleInstagram = false;
        });
    });
    githubController.addListener(() {
      if (githubController.text.length > 0) {
        setState(() {
          _visibleGit = true;
        });
      } else
        setState(() {
          _visibleGit = false;
        });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(id: user.id).userData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            _setUserToController(userData);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: userData.color.toString().isNotEmpty
                    ? Color(userData.color)
                    : defaultColor,
                actions: [
                  FlatButton(
                    shape: CircleBorder(),
                    onPressed: () {
                      _clearController();
                      _undoFlushBar(
                        context,
                        'Data cleared successfully',
                        'Undo',
                        userData,
                      );
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FlatButton(
                    shape: CircleBorder(),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(id: user.id).setUserData(
                            userData.shared,
                            userData.color,
                            userData.token,
                            userData.font,
                            userData.image,
                            nameController.text,
                            jobController.text,
                            phoneController.text,
                            mailController.text,
                            locationController.text,
                            linkController.text,
                            twitterController.text,
                            facebookController.text,
                            instagramController.text,
                            githubController.text);
                        _flushBar.flushBar(
                          context,
                          'Data saved successfully',
                          'Home',
                          Color(userData.color),
                          Colors.white,
                          false,
                        );
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: _buildTile(userData),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  void _undoFlushBar(BuildContext context, String messageText,
      String buttonTitle, UserData userData) {
    Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(20),
      borderRadius: 8.0,
      backgroundColor: Color(userData.color),
      mainButton: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            const Radius.circular(20.0),
          ),
        ),
        onPressed: () {
          _setUserToController(userData);
          Navigator.pop(context);
        },
        child: Text(
          buttonTitle,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      messageText: Text(
        messageText,
        style: TextStyle(color: Colors.white, fontSize: 14.0),
      ),
      duration: const Duration(seconds: 3),
    )..show(context);
  }

  Widget _buildTile(UserData user) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 80.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //User image picked with image_picker
            user.image.isEmpty
                ? EmptyUserImage(
                    50.0,
                    Icon(
                      Icons.add_a_photo,
                      size: 30.0,
                      color: Colors.white,
                    ),
                  )
                : UserImage(50.0),
            // Name
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                Icons.account_circle,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return val = "Name can't be empty";
                    } else {
                      return null;
                    }
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Full name',
                    suffixIcon: _visibleName
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                nameController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Job description container
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                Icons.work,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return val = "Job can't be empty";
                    } else {
                      return null;
                    }
                  },
                  controller: jobController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Job description',
                    suffixIcon: _visibleJob
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                jobController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Phone number
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                Icons.phone,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                    suffixIcon: _visiblePhone
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                phoneController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Mail
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                Icons.mail,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return null;
                    } else if (!val.contains('@')) {
                      return val = 'Email must contain the @ symbol';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: mailController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    suffixIcon: _visibleMail
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                mailController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Location
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                Icons.location_city,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                    suffixIcon: _visibleLocation
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                locationController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Link
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                Icons.link,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return null;
                    } else if (val.contains('https://')) {
                      return val = 'Enter link without https://';
                    } else if (val.contains('http://')) {
                      return val = 'Enter link without http://';
                    } else {
                      return null;
                    }
                  },
                  controller: linkController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Link',
                    suffixIcon: _visibleLink
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                linkController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Twitter
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                SociaIcons.twitter,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return null;
                    } else if (val.contains('https://twitter.com')) {
                      return val = 'Enter only account name';
                    } else if (val.contains('twitter.com')) {
                      return val = 'Enter only account name';
                    } else if (val.contains('http://')) {
                      return val = 'Enter without http://';
                    } else {
                      return null;
                    }
                  },
                  controller: twitterController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Twitter',
                    suffixIcon: _visibleTwitter
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                twitterController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Facebook
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                SociaIcons.facebook,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return null;
                    } else if (val.contains('https://')) {
                      return val =
                          'Enter only account id like profile.php?id=***************';
                    } else if (val.contains('https://www.facebook.com/')) {
                      return val =
                          'Enter only account id like profile.php?id=***************';
                    } else {
                      return null;
                    }
                  },
                  controller: facebookController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Facebook',
                    suffixIcon: _visibleFacebook
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                facebookController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Instagram
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                SociaIcons.instagram,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return null;
                    } else if (val.contains('https://www.instagram.com')) {
                      return val = 'Enter only account name';
                    } else if (val.contains('http://')) {
                      return val = 'Enter only account name';
                    } else if (val.contains('@')) {
                      return val = 'Enter only account name';
                    } else {
                      return null;
                    }
                  },
                  controller: instagramController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Instagram',
                    suffixIcon: _visibleInstagram
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                instagramController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            //Github
            ListTile(
              contentPadding: EdgeInsets.only(right: 50, bottom: 5),
              leading: Icon(
                SociaIcons.github,
                color: Color(user.color),
                size: 22.0,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Color(user.color),
                ),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return null;
                    } else if (val.contains('https://www.instagram.com')) {
                      return val = 'Enter only account name like /Name';
                    } else if (val.contains('http://')) {
                      return val = 'Enter only account name like /Name';
                    } else if (val.contains('@')) {
                      return val = 'Enter only account name like /Name';
                    } else {
                      return null;
                    }
                  },
                  controller: githubController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    labelText: 'Github',
                    suffixIcon: _visibleGit
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                githubController.text = '';
                              });
                            },
                          )
                        : Container(
                            height: 1,
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
