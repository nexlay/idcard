import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:idcard/database/database_helper.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database/user.dart';
import 'package:flushbar/flushbar.dart';

class UserDataCreator extends StatefulWidget {
  final User user;

  UserDataCreator(this.user);

  @override
  State<StatefulWidget> createState() {
    return _CreatorState(this.user);
  }
}

class _CreatorState extends State<UserDataCreator> {
  //User object
  User user;

  //Default avatar image
  File _image;

  //Default path to the local app directory
  String path;

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

  //Constructor take User object from IdCreator class
  _CreatorState(this.user);

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

  //Instance of DbHelper class
  DataBaseHelper _dbHelper = DataBaseHelper();

  //List of Users data
  List<User> list;

  @override
  void initState() {
    super.initState();

    if (list == null) {
      list = List<User>();
    }
    _getPath();

    _updateListFromDb();

    _setUserToController();

    _addListener();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
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

  //Here we get list from our database
  Future<List<User>> _updateListFromDb() async {
    final Future<Database> db = _dbHelper.initDatabase();
    db.then((database) {
      Future<List<User>> listFuture = _dbHelper.getUserList();
      listFuture.then((listOfData) {
        setState(() {
          this.list = listOfData;
        });
      });
    });
    return list;
  }

  //Update User object with new parameters
  User _updateUser() {
    if (user.image == null) {
      user.image = '';
    } else if (_image == null) {
      user.image = user.image;
    } else {
      user.image = _image.path;
    }
    user.name = nameController.text;
    user.job = jobController.text;
    user.phone = phoneController.text;
    user.mail = mailController.text;
    user.link = linkController.text;
    user.location = locationController.text;
    user.twitter = twitterController.text;
    user.facebook = facebookController.text;
    user.instagram = instagramController.text;
    user.github = githubController.text;
    return user;
  }

  //Set data from database to particular TextFields when User want to Edit data
  _setUserToController() {
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
  _addListener() {
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
  }

  void _update() async {
    await _dbHelper.insert(_updateUser());
    print('updateeeed ' + user.name);
  }

  //Get directory where we can duplicate selected file.
  Future _getPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String directoryPath = directory.path;
    setState(() {
      path = directoryPath;
    });
  }

  // Get image from gallery and save it to app directory
  Future _getImageFromGall() async {
    //Take picture from gallery
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    //Retrieve original name of the file
    var fileName = basename(image.path);
    //Copy image to the app directory
    final File localImage = await image.copy('$path/$fileName');
    //Save image/file path as string to the local database
    setState(() {
      _image = localImage;
      user.image = _image.path;
      _update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(user.color),
        actions: [
          list.isNotEmpty
              ? FlatButton(
                  shape: CircleBorder(),
                  onPressed: () {
                    if (list.isNotEmpty) {
                      _clearController();
                      _flushBar(
                          context, 'Undo', 'Data cleared successfully', true);
                    } else
                      return;
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
          FlatButton(
            shape: CircleBorder(),
            onPressed: () {
              _update();
              _flushBar(context, 'Home', 'Data saved successfully', false);
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
        child: _buildTile(context),
      )),
    );
  }

  //Alert Dialog shown if user delete the data
  Widget _buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('?'),
      content: Text(
          'All this apps data will be deleted. This includes all informations, databases, etc.'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      actions: [
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Color(user.color),
            ),
          ),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          onPressed: () {},
          child: Text(
            'OK',
            style: TextStyle(
              color: Color(user.color),
            ),
          ),
        )
      ],
    );
  }

  //Pop up notification when user interact with app
  void _flushBar(
      BuildContext context, String title, String message, bool flag) {
    Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(20),
      borderRadius: 8.0,
      backgroundColor: Color(user.color),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 14.0),
      ),
      duration: const Duration(seconds: 3),
      mainButton: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            const Radius.circular(20.0),
          ),
        ),
        onPressed: () {
          if (flag) {
            _setUserToController();
            Navigator.pop(context);
            return;
          } else if (flag == false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IdCreator(),
              ),
            );
          }
        },
        child: Text(
          title,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    )..show(context);
  }

  Widget _buildTile(context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 80.0),
      child: Column(
        children: [
          // Place where user can change his profile image
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 30.0, bottom: 30),
            child: CircleAvatar(
              backgroundImage: user.image.isEmpty
                  ? null
                  : FileImage(
                      File(user.image),
                    ),
              backgroundColor: Color(user.color),
              radius: 50,
              child: GestureDetector(
                child: user.image.isEmpty
                    ? Icon(
                        Icons.add_a_photo,
                        size: 35,
                        color: Colors.white,
                      )
                    : null,
                onTap: () {
                  _getImageFromGall();
                },
              ),
            ),
          ),

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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
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
    );
  }
}
