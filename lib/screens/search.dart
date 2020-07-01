import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idcard/custom/loading.dart';
import 'package:idcard/custom/popup.dart';
import 'package:idcard/custom/popup_content.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/search_user.dart';
import 'package:idcard/models/user.dart';
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
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(id: user.id).userData,
      builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data;
          return StreamBuilder<List<SearchUsers>>(
            stream: DatabaseService(id: user.id).allUsers,
            builder: (BuildContext context,
                AsyncSnapshot<List<SearchUsers>> snapshot) {
              if (snapshot.hasData) {
                final result =
                    snapshot.data.where((u) => u.name.contains(query)).toList();
                return ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSingleTile(
                        result[index], user.id, userData.name, context);
                  },
                );
              } else
                return Center(
                  child: Loading(),
                );
            },
          );
        } else
          return Center(
            child: Loading(),
          );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(id: user.id).userData,
      builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data;
          return StreamBuilder<List<SearchUsers>>(
            stream: DatabaseService(id: user.id).allUsers,
            builder: (BuildContext context,
                AsyncSnapshot<List<SearchUsers>> snapshot) {
              if (snapshot.hasData) {
                final result =
                    snapshot.data.where((u) => u.name.contains(query)).toList();
                return ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSingleTile(
                        result[index], user.id, userData.name, context);
                  },
                );
              } else
                return Center(
                  child: Loading(),
                );
            },
          );
        } else
          return Center(
            child: Loading(),
          );
      },
    );
  }

  _showPopup(
      BuildContext context, SearchUsers users, String id, String followedName) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          id: id,
          followedName: followedName,
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
  Widget _buildSingleTile(
      SearchUsers users, String id, String name, BuildContext context) {
    return users.shared == false
        ? Container(
            height: 0.01,
            color: Colors.white,
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: users.color.toString().isNotEmpty
                  ? Color(users.color)
                  : defaultColor,
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Place where user can change his profile image
                        users.name.isEmpty
                            ? Container()
                            : users.image.isEmpty
                                ? CircleAvatar(
                                    radius: 50.0,
                                    child: Icon(
                                      Icons.perm_identity,
                                      color: users.color.toString().isNotEmpty
                                          ? Color(users.color)
                                          : defaultColor,
                                      size: 36.0,
                                    ),
                                    backgroundColor: Colors.white,
                                  )
                                : CircleAvatar(
                                    backgroundImage: users.image != null
                                        ? NetworkImage(users.image)
                                        : Container(),
                                    radius: 50.0,
                                    backgroundColor:
                                        users.color.toString().isNotEmpty
                                            ? Color(users.color)
                                            : defaultColor,
                                  ),
                        ButtonBar(
                          children: [
                            OutlineButton(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              highlightedBorderColor: Color(users.color),
                              onPressed: () {
                                _showPopup(context, users, id, name);
                              },
                              child: Text(
                                'Read',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Name
                        users.name.isNotEmpty
                            ? Text(
                                users.name,
                                style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontFamily: users.font.isNotEmpty
                                        ? users.font
                                        : defaultFont),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
