import 'package:flutter/material.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/user_image/empty_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:idcard/dialog/alert_dialog.dart';
import '../dialog/flushbar.dart';

class PopupContent extends StatefulWidget {
  final String id;
  final String followedName;
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
      this.id,
      this.followedName,
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
  final FlushBar _flushBar = FlushBar();
  final DialogPopUp _dialogPopUp = DialogPopUp();

  //A default color of the screen
  Color defaultColor = Colors.teal;
  //A default Name font style
  String defaultFont = 'Pacifico';

  bool favorite = false;

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
      backgroundColor: Color(widget.color),
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            color: favorite ? Colors.red : Colors.white,
            onPressed: () async {
              if (favorite) {
                _showAlertDialog('Unlike ${widget.name}?',
                    'Data will be deleted from your list of favorites', 5);
              } else {
                await DatabaseService(id: widget.id).addFavoriteUsers(
                  widget.name,
                  widget.token,
                  widget.followedName,
                );

                _flushBar.flushBar(context, 'Request sanded successfully',
                    'Hide', Colors.white, Colors.black, true);

                setState(() {
                  favorite = true;
                });
              }
            },
          ),
        ],
        backgroundColor: Color(widget.color),
        leading: new Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.clear),
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
      body: Center(
        child: _buildPopUp(
            widget.shared,
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
            widget.github,
            context),
      ),
    );
  }

  //PopUp screen UI
  Widget _buildPopUp(
      bool shared,
      int color,
      String token,
      String font,
      String image,
      String name,
      String job,
      String phone,
      String mail,
      String location,
      String link,
      String twitter,
      String facebook,
      String instagram,
      String github,
      BuildContext context) {
    return shared == false
        ? Container(
            height: 1,
            color: Colors.white,
          )
        : SingleChildScrollView(
            child: Container(
              color: Color(widget.color),
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Place where user can change his profile image
                  name.isEmpty
                      ? Container()
                      : image.isEmpty
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
                                backgroundImage: image != null
                                    ? NetworkImage(image)
                                    : Container(),
                                radius: 60.0,
                                backgroundColor: color.toString().isNotEmpty
                                    ? Color(color)
                                    : defaultColor,
                              ),
                            ),
                  //Name
                  name.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontFamily:
                                    font.isNotEmpty ? font : defaultFont),
                          ),
                        )
                      : Container(),

                  //Job
                  job.isNotEmpty
                      ? Text(
                          job.toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      : Container(),
                  favorite == true
                      //Phone
                      ? Column(
                          children: [
                            job.isNotEmpty
                                ? Divider(
                                    color: Colors.white,
                                    endIndent: 40,
                                    indent: 40,
                                    thickness: 1,
                                    height: 50,
                                  )
                                : Container(),

                            phone.isNotEmpty
                                ? Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.phone,
                                        color: color != null
                                            ? Color(color)
                                            : defaultColor,
                                      ),
                                      title: Text(
                                        phone,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        _uriLauncher('tel:' + phone);
                                      },
                                      onLongPress: () {
                                        // _deleteSingleTile(context, user.id);
                                      },
                                    ),
                                  )
                                : Container(),

                            //Mail
                            mail.isNotEmpty
                                ? Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.mail,
                                        color: color != null
                                            ? Color(color)
                                            : defaultColor,
                                      ),
                                      title: Text(
                                        mail,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        _uriLauncher('mailto: ' +
                                            mail +
                                            '?subject=Write a subject you interested in, please&body=');
                                      },
                                      onLongPress: () {
                                        // _deleteSingleTile(context, user.id);
                                      },
                                    ),
                                  )
                                : Container(),

                            //Location
                            location.isNotEmpty
                                ? Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.location_city,
                                        color: color != null
                                            ? Color(color)
                                            : defaultColor,
                                      ),
                                      title: Text(
                                        location,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        _uriLauncher(
                                            'https://www.google.com/maps/search/?api=1&query=' +
                                                location);
                                      },
                                      onLongPress: () {
                                        // _deleteSingleTile(context, user.id);
                                      },
                                    ),
                                  )
                                : Container(),

                            //Link
                            link.isEmpty
                                ? Container()
                                : Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.link,
                                        color: color != null
                                            ? Color(color)
                                            : defaultColor,
                                      ),
                                      title: Text(
                                        link,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        _uriLauncher('https://' + link);
                                      },
                                      onLongPress: () {
                                        // _deleteSingleTile(context, user.id);
                                      },
                                    ),
                                  ),

                            //Twitter
                            twitter.isNotEmpty
                                ? Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Icon(
                                        SociaIcons.twitter,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                        twitter,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        _uriLauncher(
                                            'https://twitter.com/' + twitter);
                                      },
                                      onLongPress: () {
                                        // _deleteSingleTile(context, user.id);
                                      },
                                    ),
                                  )
                                : Container(),

                            //Facebook
                            facebook.isNotEmpty
                                ? Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Icon(
                                        SociaIcons.facebook,
                                        color: Colors.blue[900],
                                      ),
                                      title: Text(
                                        facebook,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        _uriLauncher(
                                            'https://www.facebook.com/profile.php?id=' +
                                                facebook);
                                      },
                                      onLongPress: () {
                                        // _deleteSingleTile(context, user.id);
                                      },
                                    ),
                                  )
                                : Container(),

                            //Instagram
                            instagram.isNotEmpty
                                ? Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Icon(
                                        SociaIcons.instagram,
                                        color: Colors.red[700],
                                      ),
                                      title: Text(
                                        instagram,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        _uriLauncher(
                                            'https://www.instagram.com/' +
                                                instagram);
                                      },
                                      onLongPress: () {
                                        // _deleteSingleTile(context, user.id);
                                      },
                                    ),
                                  )
                                : Container(),

                            //Git
                            github.isNotEmpty
                                ? Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Icon(
                                        SociaIcons.github,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                        github,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        _uriLauncher(
                                            'https://github.com/' + github);
                                      },
                                      onLongPress: () {
                                        // _deleteSingleTile(context, user.id);
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : Container(
                          child: Column(
                            children: [
                              //Phone
                              phone.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.phone,
                                          color: color != null
                                              ? Color(color)
                                              : defaultColor,
                                        ),
                                        title: Text(
                                          phone.length > 6
                                              ? '******' + phone.substring(6)
                                              : '******',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),

                              //Mail
                              mail.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.mail,
                                          color: color != null
                                              ? Color(color)
                                              : defaultColor,
                                        ),
                                        title: Text(
                                          '******' + mail.substring(15),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),

                              //Location
                              location.isNotEmpty
                                  ? Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.location_city,
                                          color: color != null
                                              ? Color(color)
                                              : defaultColor,
                                        ),
                                        title: location.length > 15
                                            ? Text(
                                                '******' +
                                                    location.substring(15),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              )
                                            : Text('******'),
                                      ),
                                    )
                                  : Container(),

                              //Link
                              link.isEmpty
                                  ? Container()
                                  : Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.link,
                                          color: color != null
                                              ? Color(color)
                                              : defaultColor,
                                        ),
                                        title: link.length > 20
                                            ? Text(
                                                '******' + link.substring(20),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              )
                                            : Text('******'),
                                      ),
                                    ),

                              //Twitter
                              twitter.isNotEmpty
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
                              facebook.isNotEmpty
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
                              instagram.isNotEmpty
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
                              github.isNotEmpty
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
          );
  }

  _uriLauncher(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  //Simply show AlertDialog
  void _showAlertDialog(String title, String content, int flag) => showDialog(
        context: context,
        builder: (_) => _dialogPopUp.buildAlertDialog(context, widget.color,
            widget.id, widget.token, title, content, flag),
      );
}
