import 'package:flutter/material.dart';
import 'package:idcard/custom/loading.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/user.dart';
import 'package:idcard/user_image/empty_image.dart';
import 'package:idcard/user_image/not_empty_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeUserList extends StatefulWidget {
  @override
  _HomeUserListState createState() => _HomeUserListState();
}

class _HomeUserListState extends State<HomeUserList> {
  //A default color of the screen
  Color defaultColor = Colors.teal;

  //A default Name font style
  String defaultFont = 'Pacifico';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(id: user.id).userData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return _buildSingleTile(userData);
          } else {
            return Loading();
          }
        });
  }

  _uriLauncher(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  //Single tile for user data list
  Widget _buildSingleTile(UserData userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userData.image.isEmpty
            ? EmptyUserImage(
                70.0,
                Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                  size: 38,
                ),
              )
            : UserImage(80.0),
        //Name
        userData.name.isNotEmpty
            ? Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  userData.name,
                  style: TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontFamily: userData.font.isNotEmpty
                          ? userData.font
                          : defaultFont),
                ),
              )
            : Container(),

        //Job
        userData.job.isNotEmpty
            ? Text(
                userData.job.toUpperCase(),
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            : Container(),

        userData.job.isNotEmpty
            ? Divider(
                color: Colors.white,
                endIndent: 40,
                indent: 40,
                thickness: 1,
                height: 50,
              )
            : Container(),

        //Phone
        userData.phone.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,
                  ),
                  title: Text(
                    userData.phone,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher('tel:' + userData.phone);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Mail
        userData.mail.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.mail,
                    color: userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,
                  ),
                  title: Text(
                    userData.mail,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher('mailto: ' +
                        userData.mail +
                        '?subject=Write a subject you interested in, please&body=');
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Location
        userData.location.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color: userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,
                  ),
                  title: Text(
                    userData.location,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher(
                        'https://www.google.com/maps/search/?api=1&query=' +
                            userData.location);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Link
        userData.link.isEmpty
            ? Container()
            : Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.link,
                    color: userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,
                  ),
                  title: Text(
                    userData.link,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher('https://' + userData.link);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              ),

        //Twitter
        userData.twitter.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    SociaIcons.twitter,
                    color: Colors
                        .blue, /*userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,*/
                  ),
                  title: Text(
                    userData.twitter,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher('https://twitter.com/' + userData.twitter);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Facebook
        userData.facebook.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    SociaIcons.facebook,
                    color: Colors.blue[
                        900], /*userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,*/
                  ),
                  title: Text(
                    userData.facebook,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher('https://www.facebook.com/profile.php?id=' +
                        userData.facebook);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Instagram
        userData.instagram.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    SociaIcons.instagram,
                    color: Colors.red[
                        700], /*userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,*/
                  ),
                  title: Text(
                    userData.instagram,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher(
                        'https://www.instagram.com/' + userData.instagram);
                  },
                  onLongPress: () {
                    // _deleteSingleTile(context, user.id);
                  },
                ),
              )
            : Container(),

        //Git
        userData.github.isNotEmpty
            ? Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    SociaIcons.github,
                    color: Colors.black, //userData.color.toString().isNotEmpty
                    //? Color(userData.color)
                    //: defaultColor,
                  ),
                  title: Text(
                    userData.github,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _uriLauncher('https://github.com/' + userData.github);
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
}
