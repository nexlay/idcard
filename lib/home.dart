import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/database/database_helper.dart';
import 'package:idcard/user_data_creator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database/user.dart';
import 'dart:io';
import 'package:flushbar/flushbar.dart';

class IdCreator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatorState();
  }
}

class _CreatorState extends State<IdCreator> {
  //User with empty parameters
  User user;

  //List of colors. You can change on your own
  List<Color> colors = [
    Colors.red,
    Colors.blueGrey,
    Colors.green,
    Colors.teal,
    Colors.black,
    Colors.blue,
    Colors.brown,
    Colors.deepPurple,
    Colors.indigo,
    Colors.pink
  ];

  //A default color of the screen
  Color defaultColor = Colors.teal;

  DataBaseHelper _dbHelper = DataBaseHelper();

  //List of data from database
  List<User> data;

  //////////////////////////////////////////////////////////////////////////////
  //All methods and functions

  @override
  void initState() {
    if (data == null) {
      data = List<User>();
    }
    user = User();
    _updateFromDb();
    super.initState();
  }

  //Every time this Future is execute our List<User> updating with data from Database
  Future<List<User>> _updateFromDb() async {
    final Future<Database> db = _dbHelper.initDatabase();
    db.then((database) {
      Future<List<User>> list = _dbHelper.getUserList();
      list.then((userData) {
        setState(() {
          this.data = userData;
          if (data.isEmpty) {
            user.color = defaultColor.value;
            user.image = '';
            user.name = '';
            user.job = '';
            user.phone = '';
            user.mail = '';
            user.link = '';
            user.location = '';
            user.twitter = '';
            user.facebook = '';
            user.instagram = '';
            user.github = '';
          } else
            user = data[data.length - 1];
        });
      });
    });
    return data;
  }

  _uriLauncher(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _insert() async {
    await _dbHelper.insert(user);
  }

  //Delete only long pressed Users parameter
  void _deleteSingleTile(BuildContext context, int id) async {
    await _dbHelper.delete(id);
  }

  //Delete all Users from Database
  void _delete(BuildContext context) async {
    await _dbHelper.deleteAll();
  }

  //////////////////////////////////////////////////////////////////////////////
  //Build the UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: user.color != null ? Color(user.color) : defaultColor,
      body: _buildUserDataList(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          elevation: 2.0,
          backgroundColor: Colors.white,
          child: data.isEmpty
              ? Icon(
                  Icons.add,
                  size: 28,
                  color: user.color != null ? Color(user.color) : defaultColor,
                )
              : Icon(
                  Icons.edit,
                  size: 28,
                  color: user.color != null ? Color(user.color) : defaultColor,
                ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDataCreator(
                  user,
                ),
              ),
            );
          }),
      bottomNavigationBar: BottomAppBar(
        color: user.color != null ? Color(user.color) : defaultColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () => _bottomSheetMenuLeft(),
              icon: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () => _bottomSheetMenuRight(),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Menu shown when you tap 3 dots on appbar. You can change the height of the menu
  void _bottomSheetMenuRight() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDeleteButton(context),
            ],
          ),
        );
      },
    );
  }

  //Menu shown when you tap "+" on appbar. You can change the height of the menu
  void _bottomSheetMenuLeft() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorPicker(context),
            ],
          ),
        );
      },
    );
  }

  // It's a color palette
  Widget _buildColorPicker(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return _buildColorTile(colors[index]);
        },
      ),
    );
  }

  //It's a container for single color
  Widget _buildColorTile(Color color) {
    return Container(
      height: 50,
      width: 50,
      child: MaterialButton(
        elevation: 0.0,
        shape: CircleBorder(
            side: BorderSide(
                width: 3, color: Colors.white, style: BorderStyle.solid)),
        color: color, // button color
        onPressed: () {
          setState(() {
            defaultColor = color;
            user.color = defaultColor.value;
            _insert();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  //Button delete on bottom sheet menu (3 dots)
  Widget _buildDeleteButton(BuildContext context) {
    return Container(
      child: FlatButton.icon(
        splashColor: Colors.grey,
        highlightColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
          _showAlertDialog();
        },
        label: Text(
          'Delete',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.black,
          size: 26,
        ),
      ),
    );
  }

  void _flushBar(BuildContext context) {
    Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(20),
      borderRadius: 8.0,
      backgroundColor: Colors.white,
      mainButton: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            const Radius.circular(20.0),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'Hide',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
      ),
      messageText: const Text(
        'All data was deleted',
        style: TextStyle(color: Colors.black, fontSize: 14.0),
      ),
      duration: const Duration(seconds: 3),
    )..show(context);
  }

  //Alert Dialog shown if user delete the data
  Widget _buildAlertDialog() {
    return AlertDialog(
      title: Text('Delete app data?'),
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
              color: user.color != null ? Color(user.color) : defaultColor,
            ),
          ),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          onPressed: () {
            _delete(context);
            Navigator.pop(context);
            _flushBar(context);
          },
          child: Text(
            'OK',
            style: TextStyle(
              color: user.color != null ? Color(user.color) : defaultColor,
            ),
          ),
        )
      ],
    );
  }

  //Simply show AlertDialog
  void _showAlertDialog() =>
      showDialog(context: context, builder: (_) => _buildAlertDialog());

  // Cards with users data (phone number, name, etc.)
  Widget _buildUserDataList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
      child: FutureBuilder(
          future: _updateFromDb(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData & data.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSingleTile(snapshot.data[index]);
                  });
            } else
              return _buildEmptyListView();
          }),
    );
  }

  //Single tile for user data list
  Widget _buildSingleTile(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Place where user can change his profile image
        user.image.isNotEmpty
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: CircleAvatar(
                  backgroundColor:
                      user.color != null ? Color(user.color) : defaultColor,
                  radius: 60,
                  backgroundImage: FileImage(File(user.image)),
                ),
              )
            : Container(),

        //Name
        user.name.isNotEmpty
            ? Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  user.name,
                  style: TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontFamily: 'Pacifico'),
                ),
              )
            : Container(),

        //Job
        user.job.isNotEmpty
            ? Text(
                user.job.toUpperCase(),
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            : Container(),

        user.job.isNotEmpty
            ? Divider(
                color: Colors.white,
                endIndent: 40,
                indent: 40,
                thickness: 1,
                height: 50,
              )
            : Container(),

        //Phone
        user.phone.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color:
                        user.color != null ? Color(user.color) : defaultColor,
                  ),
                  title: Text(
                    user.phone,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher('tel:' + user.phone);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Mail
        user.mail.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.mail,
                    color:
                        user.color != null ? Color(user.color) : defaultColor,
                  ),
                  title: Text(
                    user.mail,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher('mailto: ' +
                        user.mail +
                        '?subject=Write a subject you interested in, please&body=');
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Location
        user.location.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color:
                        user.color != null ? Color(user.color) : defaultColor,
                  ),
                  title: Text(
                    user.location,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher(
                        'https://www.google.com/maps/search/?api=1&query=' +
                            user.location);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Link
        user.link.isEmpty
            ? Container()
            : Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.link,
                    color:
                        user.color != null ? Color(user.color) : defaultColor,
                  ),
                  title: Text(
                    user.link,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher(user.link);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              ),

        //Twitter
        user.twitter.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    SociaIcons.twitter,
                    color:
                        user.color != null ? Color(user.color) : defaultColor,
                  ),
                  title: Text(
                    user.twitter,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher(user.twitter);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Facebook
        user.facebook.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    SociaIcons.facebook,
                    color:
                        user.color != null ? Color(user.color) : defaultColor,
                  ),
                  title: Text(
                    user.facebook,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher(user.facebook);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Instagram
        user.instagram.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    SociaIcons.instagram,
                    color:
                        user.color != null ? Color(user.color) : defaultColor,
                  ),
                  title: Text(
                    user.instagram,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher(user.instagram);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Git
        user.github.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    SociaIcons.github,
                    color:
                        user.color != null ? Color(user.color) : defaultColor,
                  ),
                  title: Text(
                    user.github,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher(user.github);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyListView() => Center(
        child: Image(
          width: 250,
          height: 250,
          image: AssetImage('images/id_card_empty.png'),
        ),
      );
}
