import 'package:flutter/material.dart';
import 'package:idcard/custom/popup.dart';
import 'package:idcard/custom/popup_content.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/favorites_users.dart';
import 'package:idcard/models/user.dart';
import 'package:provider/provider.dart';

class SearchFavorites extends SearchDelegate<UserData> {
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
    return StreamBuilder<List<FavoriteUsers>>(
      stream: DatabaseService(id: user.id).favoriteUser,
      builder:
          (BuildContext context, AsyncSnapshot<List<FavoriteUsers>> snapshot) {
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
    return StreamBuilder<List<FavoriteUsers>>(
      stream: DatabaseService(id: user.id).favoriteUser,
      builder:
          (BuildContext context, AsyncSnapshot<List<FavoriteUsers>> snapshot) {
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

  showPopup(BuildContext context, FavoriteUsers users, User user) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          id: user.id,
          favorite: users.favorite ?? false,
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
  Widget _buildSingleTile(FavoriteUsers users, BuildContext context) {
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
                  showPopup(context, users, user);
                },
                leading:
                    // Place where user can change his profile image
                    users.name.isEmpty
                        ? Container()
                        : users.image.isEmpty
                            ? CircleAvatar(
                                radius: 29.0,
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
}
