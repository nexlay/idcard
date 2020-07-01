import 'package:flutter/material.dart';
import 'package:idcard/custom/loading.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/dialog/alert_dialog.dart';
import 'package:idcard/models/search_user.dart';
import 'package:idcard/models/user.dart';
import 'package:idcard/screens/empty_screen.dart';
import 'package:idcard/user_image/empty_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesList extends StatefulWidget {
  final String id;
  FavoritesList({this.id});
  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  final DialogPopUp _dialogPopUp = DialogPopUp();
  //A default color of the screen
  Color defaultColor = Colors.teal;
  //A default Name font style
  String defaultFont = 'Pacifico';

  //List of favorites users tokens
  List<String> token = [];
  //Favorites users objects list
  List<SearchUsers> favoriteList = [];

  _uriLauncher(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  void initState() {
    DatabaseService(id: widget.id).getFavoritesTokens().then((tokens) {
      setState(() {
        token = tokens;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final favorites = Provider.of<List<SearchUsers>>(context) ?? [];

    if (favorites.isNotEmpty) {
      for (int i = 0; i < token.length; i++) {
        favorites.forEach((element) {
          if (token[i] == element.token) {
            favoriteList.add(element);
          }
        });
      }
    } else
      return Loading();

    return ListView.builder(
        itemCount: token.length,
        itemBuilder: (BuildContext context, int index) {
          if (favoriteList.isNotEmpty) {
            return _buildSingleTile(favoriteList[index], user);
          } else
            return EmptyListView().buildEmptyListView(Colors.grey[300],
                "No favorite jet...", "Try to search some users!");
        });
  }

//Single tile for user data list
  Widget _buildSingleTile(SearchUsers users, User user) {
    return users.shared == false
        ? Container(
            height: 1,
            color: Colors.white,
          )
        : Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Card(
              color: users.color.toString().isNotEmpty
                  ? Color(users.color)
                  : defaultColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.star),
                          color: users.shared ? Colors.red : Colors.white,
                          onPressed: () async {
                            if (users.shared) {
                              _showAlertDialog(
                                  user,
                                  users,
                                  '${users.name}?',
                                  'Data will be deleted from your list of favorites',
                                  5);
                            } else {
                              await DatabaseService(id: user.id)
                                  .updateFavoriteUser(true, users.token);
                            }
                          },
                        ),
                      ],
                    ),
                    // Place where user can change his profile image
                    users.name.isEmpty
                        ? Container()
                        : users.image.isEmpty
                            ? EmptyUserImage(
                                70.0,
                                Icon(
                                  Icons.perm_identity,
                                  color: Colors.white,
                                  size: 38,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: CircleAvatar(
                                  backgroundImage: users.image != null
                                      ? NetworkImage(users.image)
                                      : Container(),
                                  radius: 70.0,
                                  backgroundColor:
                                      users.color.toString().isNotEmpty
                                          ? Color(users.color)
                                          : defaultColor,
                                ),
                              ),

                    //Name
                    users.name.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              users.name,
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontFamily: users.font.isNotEmpty
                                      ? users.font
                                      : defaultFont),
                            ),
                          )
                        : Container(),

                    //Job
                    users.job.isNotEmpty
                        ? Text(
                            users.job.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 2.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : Container(),

                    users.job.isNotEmpty
                        ? Divider(
                            color: Colors.white,
                            endIndent: 40,
                            indent: 40,
                            thickness: 1,
                            height: 50,
                          )
                        : Container(),

                    users.shared
                        ? Column(
                            children: [
                              //Phone
                              users.phone.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.phone,
                                          color: users.color != null
                                              ? Color(users.color)
                                              : defaultColor,
                                        ),
                                        title: Text(
                                          users.phone,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _uriLauncher('tel:' + users.phone);
                                        },
                                      ),
                                    )
                                  : Container(),

                              //Mail
                              users.mail.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.mail,
                                          color: users.color != null
                                              ? Color(users.color)
                                              : defaultColor,
                                        ),
                                        title: Text(
                                          users.mail,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _uriLauncher('mailto: ' +
                                              users.mail +
                                              '?subject=Write a subject you interested in, please&body=');
                                        },
                                      ),
                                    )
                                  : Container(),

                              //Location
                              users.location.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.location_city,
                                          color: users.color != null
                                              ? Color(users.color)
                                              : defaultColor,
                                        ),
                                        title: Text(
                                          users.location,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _uriLauncher(
                                              'https://www.google.com/maps/search/?api=1&query=' +
                                                  users.location);
                                        },
                                      ),
                                    )
                                  : Container(),

                              //Link
                              users.link.isEmpty
                                  ? Container()
                                  : Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.link,
                                          color: users.color != null
                                              ? Color(users.color)
                                              : defaultColor,
                                        ),
                                        title: Text(
                                          users.link,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _uriLauncher('https://' + users.link);
                                        },
                                      ),
                                    ),

                              //Twitter
                              users.twitter.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          SociaIcons.twitter,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          users.twitter,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _uriLauncher('https://twitter.com/' +
                                              users.twitter);
                                        },
                                      ),
                                    )
                                  : Container(),

                              //Facebook
                              users.facebook.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          SociaIcons.facebook,
                                          color: Colors.blue[900],
                                        ),
                                        title: Text(
                                          users.facebook,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _uriLauncher(
                                              'https://www.facebook.com/profile.php?id=' +
                                                  users.facebook);
                                        },
                                      ),
                                    )
                                  : Container(),

                              //Instagram
                              users.instagram.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          SociaIcons.instagram,
                                          color: Colors.red[700],
                                        ),
                                        title: Text(
                                          users.instagram,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _uriLauncher(
                                              'https://www.instagram.com/' +
                                                  users.instagram);
                                        },
                                      ),
                                    )
                                  : Container(),

                              //Git
                              users.github.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          SociaIcons.github,
                                          color: Colors.black,
                                        ),
                                        title: Text(
                                          users.github,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        onTap: () {
                                          _uriLauncher('https://github.com/' +
                                              users.github);
                                        },
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        //If user isn't accept 'favorite' request
                        : Container(
                            child: Column(
                              children: [
                                //Phone
                                users.phone.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.phone,
                                            color: users.color != null
                                                ? Color(users.color)
                                                : defaultColor,
                                          ),
                                          title: Text(
                                            users.phone.length > 6
                                                ? '******' +
                                                    users.phone.substring(6)
                                                : '******',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),

                                //Mail
                                users.mail.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.mail,
                                            color: users.color != null
                                                ? Color(users.color)
                                                : defaultColor,
                                          ),
                                          title: Text(
                                            '******' + users.mail.substring(15),
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),

                                //Location
                                users.location.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.location_city,
                                            color: users.color != null
                                                ? Color(users.color)
                                                : defaultColor,
                                          ),
                                          title: users.location.length > 15
                                              ? Text(
                                                  '******' +
                                                      users.location
                                                          .substring(15),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                )
                                              : Text('******'),
                                        ),
                                      )
                                    : Container(),

                                //Link
                                users.link.isEmpty
                                    ? Container()
                                    : Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.link,
                                            color: users.color != null
                                                ? Color(users.color)
                                                : defaultColor,
                                          ),
                                          title: Text(
                                            '******' + users.link.substring(20),
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),

                                //Twitter
                                users.twitter.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Icon(
                                            SociaIcons.twitter,
                                            color: Colors.blue,
                                          ),
                                          title: Text(
                                            '******',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),

                                //Facebook
                                users.facebook.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Icon(
                                            SociaIcons.facebook,
                                            color: Colors.blue[900],
                                          ),
                                          title: Text(
                                            '******',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),

                                //Instagram
                                users.instagram.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Icon(
                                            SociaIcons.instagram,
                                            color: Colors.red[700],
                                          ),
                                          title: Text(
                                            '******',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),

                                //Git
                                users.github.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Icon(
                                            SociaIcons.github,
                                            color: Colors.black,
                                          ),
                                          title: Text(
                                            '******',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }

  //Simply show AlertDialog
  void _showAlertDialog(User user, SearchUsers users, String title,
          String content, int flag) =>
      showDialog(
        context: context,
        builder: (_) => _dialogPopUp.buildAlertDialog(
            context, users.color, user.id, users.token, title, content, flag),
      );
}
