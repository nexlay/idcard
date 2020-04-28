import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/database/database_helper.dart';
import 'package:idcard/user_data_creator.dart';
import 'package:sqflite/sqflite.dart';
import 'database/user.dart';
import 'dart:io';

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
          if (data.isNotEmpty) {
            for (int i = 0; i < data.length; i++) {
              user = data[i];
            }
          }
        });
      });
    });

    return data;
  }

  //If the User object is first added send object with empty parameters, else take present object
  _insertUser() {
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
    }
    for (int i = 0; i < data.length; i++) {
      user = data[i];
    }
    return user;
  }

  void _insert() async {
    await _dbHelper.insert(_insertUser());
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
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            size: 28,
            color: user.color != null ? Color(user.color) : defaultColor,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserDataCreator(_insertUser())));
          }),
      bottomNavigationBar: BottomAppBar(
        color: user.color != null ? Color(user.color) : defaultColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () => _bottomSheetMenu(),
              icon: Icon(
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
  void _bottomSheetMenu() {
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
          });
          _insert();
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Container(
      child: FloatingActionButton.extended(
        onPressed: () {
          _delete(context);
          Navigator.pop(context);
        },
        label: Text(
          'Delete',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        icon: Icon(
          Icons.delete,
          color: Colors.black,
          size: 26,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  // Cards with users data (phone number, name, etc.)
  Widget _buildUserDataList(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _updateFromDb(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSingleTile(snapshot.data[index]);
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            }
          }),
    );
  }

  //Single tile for user data list
  Widget _buildSingleTile(User user) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Place where user can change his profile image
        user.image.isNotEmpty
            ? CircleAvatar(
                backgroundColor:
                    user.color != null ? Color(user.color) : defaultColor,
                radius: 60,
                backgroundImage: FileImage(File(user.image)),
              )
            : Container(),
        user.name.isNotEmpty
            ? Text(
                user.name,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Pacifico'),
              )
            : Container(),
        user.job.isNotEmpty
            ? Text(
                user.job.toUpperCase(),
                style: TextStyle(
                    fontSize: 18,
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
              )
            : Container(),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              ),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
