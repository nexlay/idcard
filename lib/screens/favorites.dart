import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:idcard/database/database.dart';
import 'package:idcard/lists/favorites_list.dart';

import 'package:idcard/models/search_user.dart';
import 'package:idcard/models/user.dart';

import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  final Color color;
  Favorites({this.color});
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<SearchUsers>>.value(
      value: DatabaseService(id: user.id).allUsers,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.0,
          title: Text('Favorites'),
          backgroundColor: widget.color,
        ),
        body: FavoritesList(id: user.id),
      ),
    );
  }
}
