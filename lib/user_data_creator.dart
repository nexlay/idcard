import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idcard/database/database_helper.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database/user.dart';

class UserDataCreator extends StatefulWidget {
  final User user;
  //final Color pickedColor;

  UserDataCreator(this.user); //, this.pickedColor);

  @override
  State<StatefulWidget> createState() {
    return _CreatorState(this.user); //, this.pickedColor);
  }
}

class _CreatorState extends State<UserDataCreator> {
  //User object
  User user;

  //Default avatar image
  File _image;

  //Default path to the local app directory
  String path;

  //Color from color picker
  Color pickedColor;

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

  @override
  void dispose() {
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

  //Instance of DbHelper class
  DataBaseHelper _dbHelper = DataBaseHelper();

  //List of Users data
  List<User> list;

  @override
  void initState() {
    if (list == null) {
      list = List<User>();
    }
    _getPath();
    _updateListFromDb();
    _setUserToController();

    super.initState();
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

  void _update() async {
    await _dbHelper.insert(_updateUser());
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
    print(image);
    print('$path/$fileName');
    //Save image/file path as string to the local database
    setState(() {
      _image = localImage;
      user.image = _image.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Text(
          'Save',
          style: TextStyle(color: Color(user.color), fontSize: 16),
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          _update();
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Container(
          child: _buildUserCreator(context),
        ),
      ),
    );
  }

  Widget _buildUserCreator(BuildContext context) {
    return FutureBuilder(
      future: _updateListFromDb(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return _buildTile(context);
          },
        );
      },
    );
  }

  Widget _buildTile(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 70, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Place where user can change his profile image
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: CircleAvatar(
              backgroundImage:
                  user.image.isEmpty ? null : FileImage(File(user.image)),
              backgroundColor: Color(user.color),
              radius: 40,
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
            leading: Icon(
              Icons.account_circle,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Full name',
                ),
              ),
            ),
          ),

          //Job description container
          ListTile(
            leading: Icon(
              Icons.work,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                controller: jobController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Job description',
                ),
              ),
            ),
          ),

          //Phone number
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: phoneController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                ),
              ),
            ),
          ),

          //Mail
          ListTile(
            leading: Icon(
              Icons.mail,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: mailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Mail',
                ),
              ),
            ),
          ),

          //Link
          ListTile(
            leading: Icon(
              Icons.link,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                controller: linkController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Link',
                ),
              ),
            ),
          ),
          //Location
          ListTile(
            leading: Icon(
              Icons.location_city,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
          ),

          //Twitter
          ListTile(
            leading: Icon(
              SociaIcons.twitter,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                controller: twitterController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Twitter',
                ),
              ),
            ),
          ),

          //Facebook
          ListTile(
            leading: Icon(
              SociaIcons.facebook,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                controller: facebookController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Facebook',
                ),
              ),
            ),
          ),

          //Instagram
          ListTile(
            leading: Icon(
              SociaIcons.instagram,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                controller: instagramController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Instagram',
                ),
              ),
            ),
          ),

          //Github
          ListTile(
            leading: Icon(
              SociaIcons.github,
              color: Color(user.color),
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color(user.color),
              ),
              child: TextField(
                controller: githubController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(),
                  labelText: 'Github',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
