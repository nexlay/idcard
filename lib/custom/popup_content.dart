import 'package:flutter/material.dart';
import 'package:idcard/database/database.dart';

class PopupContent extends StatefulWidget {
  final Widget widget;
  final String id;
  final bool shared;
  final int color;
  final String token;
  final String font;
  final String image;
  final String name;
  final String job;
  final String phone;
  final String mail;
  final String location;
  final String link;
  final String twitter;
  final String facebook;
  final String instagram;
  final String github;

  PopupContent(
      {Key key,
      this.widget,
      this.id,
      this.shared,
      this.token,
      this.font,
      this.color,
      this.image,
      this.name,
      this.job,
      this.phone,
      this.mail,
      this.link,
      this.location,
      this.twitter,
      this.facebook,
      this.instagram,
      this.github})
      : super(key: key);

  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  bool favorite;

  @override
  void initState() {
    DatabaseService(id: widget.id).checkExist(widget.token).then((value) {
      setState(() {
        favorite = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            color: widget.shared ? Colors.red : Colors.black,
            onPressed: () async {
              await DatabaseService(id: widget.id).addFavoriteUsers(
                  widget.shared,
                  false,
                  widget.color,
                  widget.token,
                  widget.font,
                  widget.image,
                  widget.name,
                  widget.job,
                  widget.phone,
                  widget.mail,
                  widget.location,
                  widget.link,
                  widget.twitter,
                  widget.facebook,
                  widget.instagram,
                  widget.github);

              await DatabaseService(id: widget.id)
                  .updateFavoriteUser(true, widget.token);
            },
          ),
        ],
        backgroundColor: Colors.white,
        leading: new Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.clear),
            color: Colors.black,
            onPressed: () {
              try {
                Navigator.pop(context); //close the popup
              } catch (e) {}
            },
          );
        }),
        brightness: Brightness.light,
      ),
      resizeToAvoidBottomPadding: false,
      body: widget.widget,
    );
  }
}
