import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/lists/favorites_list.dart';
import 'package:idcard/models/favorites_users.dart';
import 'package:idcard/models/user.dart';
import 'package:idcard/screens/search_favorite.dart';
import 'package:provider/provider.dart';

class Favorites extends StatelessWidget {
  final Color color;
  Favorites({this.color});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<FavoriteUsers>>.value(
      value: DatabaseService(id: user.id).favoriteUser,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Favorites'),
          actions: [
            IconButton(
              icon: Icon(SociaIcons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchFavorites(),
                );
              },
            ),
          ],
          backgroundColor: color,
        ),
        body: FavoritesList(),
      ),
    );
  }
}
