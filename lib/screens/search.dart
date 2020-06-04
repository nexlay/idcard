import 'package:flutter/material.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/search_user.dart';
import 'package:idcard/models/user.dart';
import 'file:///D:/flutter_projects/idcard/lib/custom/popup_content.dart';
import 'file:///D:/flutter_projects/idcard/lib/custom/popup.dart';
import 'package:idcard/user_image/empty_image.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate<UserData> {
  //A default color of the screen
  Color defaultColor = Colors.teal;
  //A default Name font style
  String defaultFont = 'Pacifico';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<SearchUsers>>(
      stream: DatabaseService(id: user.id).userInfo,
      builder:
          (BuildContext context, AsyncSnapshot<List<SearchUsers>> snapshot) {
        if (snapshot.hasData) {
          final result =
              snapshot.data.where((u) => u.name.contains(query)).toList();
          return ListView.builder(
            itemCount: result.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildSingleTile(result[index], context);
            },
          );
        } else
          return Center(
            child: Text('No data!'),
          );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<SearchUsers>>(
      stream: DatabaseService(id: user.id).userInfo,
      builder:
          (BuildContext context, AsyncSnapshot<List<SearchUsers>> snapshot) {
        if (snapshot.hasData) {
          final result =
              snapshot.data.where((u) => u.name.contains(query)).toList();
          return ListView.builder(
            itemCount: result.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildSingleTile(result[index], context);
            },
          );
        } else
          return Center(
            child: Text('No data!'),
          );
      },
    );
  }

  showPopup(BuildContext context, Widget widget, SearchUsers users, User user) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          widget: widget,
          id: user.id,
          shared: users.shared,
          color: users.color,
          token: users.token,
          font: users.font,
          image: users.image,
          name: users.name,
          job: users.job,
          phone: users.phone,
          mail: users.mail,
          location: users.location,
          link: users.link,
          twitter: users.twitter,
          facebook: users.facebook,
          instagram: users.instagram,
          github: users.github,
        ),
      ),
    );
  }

  //Single tile in search suggestions
  Widget _buildSingleTile(SearchUsers users, BuildContext context) {
    final user = Provider.of<User>(context);
    return users.shared == false
        ? Container(
            height: 0.1,
            color: Colors.white,
          )
        : Container(
            height: 130,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Card(
              color: users.color.toString().isNotEmpty
                  ? Color(users.color)
                  : defaultColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: ListTile(
                onTap: () {
                  showPopup(context, _buildPopUp(users, context), users, user);
                },
                leading:
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
                            : CircleAvatar(
                                backgroundImage: users.image != null
                                    ? NetworkImage(users.image)
                                    : Container(),
                                radius: 29.0,
                                backgroundColor:
                                    users.color.toString().isNotEmpty
                                        ? Color(users.color)
                                        : defaultColor,
                              ),
                title:
                    //Name
                    users.name.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              users.name,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontFamily: users.font.isNotEmpty
                                      ? users.font
                                      : defaultFont),
                            ),
                          )
                        : Container(),
                subtitle:
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
              ),
            ),
          );
  }

  //PopUp screen UI
  Widget _buildPopUp(SearchUsers users, BuildContext context) {
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
                                  radius: 60.0,
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

                    //Phone
                    /* users.phone.isNotEmpty
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
                                  onLongPress: () {
                                    // _deleteSingleTile(context, user.id);
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
                                  onLongPress: () {
                                    // _deleteSingleTile(context, user.id);
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
                                  onLongPress: () {
                                    // _deleteSingleTile(context, user.id);
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
                                  onLongPress: () {
                                    // _deleteSingleTile(context, user.id);
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
                                    color: Colors
                                        .blue, /*user.color != null
                                        ? Color(user.color)
                                        : defaultColor,*/
                                  ),
                                  title: Text(
                                    users.twitter,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    _uriLauncher(
                                        'https://twitter.com/' + users.twitter);
                                  },
                                  onLongPress: () {
                                    // _deleteSingleTile(context, user.id);
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
                                    color: Colors.blue[
                                        900], /*user.color != null
                                        ? Color(user.color)
                                        : defaultColor,*/
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
                                  onLongPress: () {
                                    // _deleteSingleTile(context, user.id);
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
                                    color: Colors.red[
                                        700], /*user.color != null
                                        ? Color(user.color)
                                        : defaultColor,*/
                                  ),
                                  title: Text(
                                    users.instagram,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    _uriLauncher('https://www.instagram.com/' +
                                        users.instagram);
                                  },
                                  onLongPress: () {
                                    // _deleteSingleTile(context, user.id);
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
                                    color: Colors
                                        .black, /*user.color != null
                                        ? Color(user.color)
                                        : defaultColor,*/
                                  ),
                                  title: Text(
                                    users.github,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    _uriLauncher(
                                        'https://github.com/' + users.github);
                                  },
                                  onLongPress: () {
                                    // _deleteSingleTile(context, user.id);
                                  },
                                ),
                              )
                            : Container(),*/
                  ],
                ),
              ),
            ),
          );
  }
}
