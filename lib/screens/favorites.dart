import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/lists/favorites_list.dart';
import 'package:idcard/models/favorites_users.dart';
import 'package:idcard/models/user.dart';
import 'package:idcard/screens/search.dart';
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
          title: Text('Favorite'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: Search(),
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
