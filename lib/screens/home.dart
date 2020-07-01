import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:idcard/custom/loading.dart';
import 'package:idcard/custom/socia_icons_icons.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/dialog/alert_dialog.dart';
import 'package:idcard/lists/home_user_info.dart';
import 'package:idcard/models/user.dart';
import 'package:idcard/screens/empty_screen.dart';
import 'package:idcard/screens/favorites.dart';
import 'package:idcard/screens/search.dart';
import 'package:idcard/screens/user_data_creator.dart';
import 'package:idcard/screens/wrapper.dart';
import 'package:idcard/service/auth.dart';
import 'package:provider/provider.dart';

class IdCardViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatorState();
  }
}

class _CreatorState extends State<IdCardViewer> {
  final AuthUser _auth = AuthUser();

  final DialogPopUp _dialogPopUp = DialogPopUp();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //List of colors. You can change on your own
  List<Color> colors = [
    Colors.red,
    Colors.blueGrey,
    Colors.green,
    Colors.teal,
    Colors.black,
    Colors.blue,
    Colors.brown,
    Colors.deepPurple,
    Colors.indigo,
    Colors.pink
  ];

  //List of fonts to change User Name font
  List<String> fonts = [
    'FiraSans',
    'FreDokaOne',
    'Pacifico',
    'DancingScript',
    'Handlee',
    'JustAnotherHand',
    'PatrickHandSC',
    'Satisfy',
    'Courgette',
    'KaushanScript',
    'Sacramento',
  ];

  //A default color of the screen
  Color defaultColor = Colors.teal;
  //A default Name font style
  String defaultFont = 'Pacifico';

  UserData userData;

  @override
  void initState() {
    // For iOS request permission first.
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      //App is in foreground and you receive a notification
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');

        _showAlertDialog(userData, message['notification']['title'],
            message['notification']['body'], 4);
      },
      //Open app clicking on push notification
      onLaunch: (Map<String, dynamic> message) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Favorites(
              color: Color(userData.color),
            ),
          ),
        );
      },
      //App is in background
      onResume: (Map<String, dynamic> message) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Favorites(
              color: Color(userData.color),
            ),
          ),
        );
      },
    );
    super.initState();
  }

  //////////////////////////////////////////////////////////////////////////////
  //Build the UI

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user == null
        ? Wrapper()
        : StreamBuilder<UserData>(
            stream: DatabaseService(id: user.id).userData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                userData = snapshot.data;
                return Scaffold(
                  backgroundColor: userData.color != null
                      ? Color(userData.color)
                      : defaultColor,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 50.0),
                        child: userData.name.isNotEmpty
                            ? HomeUserList()
                            : EmptyListView().buildEmptyListView(
                                Color(userData.color),
                                "It's a little bit lonely here...",
                                "Try to add some content!"),
                      ),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: FloatingActionButton(
                      elevation: 2.0,
                      shape: CircleBorder(
                        side: BorderSide(
                            color: userData.color.toString().isNotEmpty
                                ? Color(userData.color)
                                : defaultColor,
                            width: 1.0),
                      ),
                      backgroundColor: Colors.white,
                      child: userData.name.isEmpty
                          ? Icon(
                              Icons.add,
                              size: 28,
                              color: userData.color.toString().isNotEmpty
                                  ? Color(userData.color)
                                  : defaultColor,
                            )
                          : Icon(
                              Icons.edit,
                              size: 28,
                              color: userData.color.toString().isNotEmpty
                                  ? Color(userData.color)
                                  : defaultColor,
                            ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDataCreator(),
                          ),
                        );
                      }),
                  appBar: AppBar(
                    elevation: 0.0,
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: Icon(SociaIcons.search),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: Search(),
                          );
                        },
                      ),
                    ],
                    backgroundColor: userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,
                  ),
                  bottomNavigationBar: BottomAppBar(
                    color: userData.color.toString().isNotEmpty
                        ? Color(userData.color)
                        : defaultColor,
                    shape: CircularNotchedRectangle(),
                    notchMargin: 6.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          onPressed: () => _bottomSheetMenuLeft(user),
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _bottomSheetMenuRight(userData),
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Loading();
              }
            });
  }

  //Menu shown when you tap 3 dots on appbar. You can change the height of the menu
  void _bottomSheetMenuRight(UserData userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              userData.shared == false
                  ? _buildShareButton(context, userData)
                  : _buildHideButton(context, userData),
              _buildDeleteButton(context, userData),
              _buildShowSharedListButton(context, userData),
              _buildSignOutButton(context, userData),
            ],
          ),
        );
      },
    );
  }

  //Menu shown when you tap "+" on appbar. You can change the height of the menu
  void _bottomSheetMenuLeft(User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFontChanger(context, user),
              _buildColorPicker(context, user),
            ],
          ),
        );
      },
    );
  }

/////////////////////////////////////////////////////////////////////////////////
  //Button delete on bottom sheet menu (3 dots)
  Widget _buildDeleteButton(BuildContext context, UserData userData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FlatButton.icon(
        splashColor: Color(userData.color),
        highlightColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
          _showAlertDialog(
              userData,
              'Delete app data?',
              'All this apps data will be deleted. This includes all informations, databases, etc.',
              1);
        },
        label: Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.black,
          size: 26,
        ),
      ),
    );
  }

  //Button share on bottom sheet menu (3 dots)
  Widget _buildShareButton(BuildContext context, UserData userData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FlatButton.icon(
        splashColor: Color(userData.color),
        highlightColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
          _showAlertDialog(userData, 'Share your data?',
              'All users can see information about you', 2);
        },
        label: Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              'Share information',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        icon: const Icon(
          Icons.share,
          color: Colors.black,
          size: 26,
        ),
      ),
    );
  }

  //Button hide on bottom sheet menu (3 dots)
  Widget _buildHideButton(BuildContext context, UserData userData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FlatButton.icon(
        splashColor: Color(userData.color),
        highlightColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);

          _showAlertDialog(userData, 'Make your data private?',
              'Other users will not be able to see information about you', 3);
        },
        label: Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              'Hide information',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        icon: const Icon(
          Icons.lock_outline,
          color: Colors.black,
          size: 26,
        ),
      ),
    );
  }

  //Button share on bottom sheet menu (3 dots)
  Widget _buildShowSharedListButton(BuildContext context, UserData userData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FlatButton.icon(
        splashColor: Color(userData.color),
        highlightColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Favorites(
                color: Color(userData.color),
              ),
            ),
          );
        },
        label: Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              'Favorites',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        icon: const Icon(
          Icons.star_border,
          color: Colors.black,
          size: 26,
        ),
      ),
    );
  }

  //Button share on bottom sheet menu (3 dots)
  Widget _buildSignOutButton(BuildContext context, UserData userData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FlatButton.icon(
        splashColor: Color(userData.color),
        highlightColor: Colors.white,
        onPressed: () async {
          await _auth.signOut();
          Navigator.pop(context);
        },
        label: Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        icon: const Icon(
          SociaIcons.logout,
          color: Colors.black,
          size: 26,
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////////

  //Simply show AlertDialog
  void _showAlertDialog(
          UserData userData, String title, String content, int flag) =>
      showDialog(
        context: context,
        builder: (_) => _dialogPopUp.buildAlertDialog(context, userData.color,
            userData.id, userData.token, title, content, flag),
      );

/////////////////////////////////////////////////////////////////////////////////////
  // It's a color palette
  Widget _buildColorPicker(BuildContext context, User user) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return _buildColorTile(colors[index], user);
        },
      ),
    );
  }

  //A container for single color
  Widget _buildColorTile(Color color, User user) {
    return Container(
      height: 50,
      width: 50,
      child: MaterialButton(
        elevation: 0.0,
        shape: CircleBorder(
          side: BorderSide(
              width: 3, color: Colors.white, style: BorderStyle.solid),
        ),
        color: color, // button color
        onPressed: () async {
          setState(() {
            defaultColor = color;
          });
          await DatabaseService(id: user.id)
              .updateUserColor(defaultColor.value);
        },
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////////
  //Build font changer
  Widget _buildFontChanger(BuildContext context, User user) {
    return Expanded(
      child: ListView.builder(
          itemCount: fonts.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            return _buildFontTile(fonts[index], user);
          }),
    );
  }

  Widget _buildFontTile(String font, User user) {
    return Container(
      height: 50,
      width: 150,
      margin: EdgeInsets.only(top: 20.0, right: 5.0),
      child: MaterialButton(
        child: Text(
          font,
          style: TextStyle(fontFamily: font, fontSize: 18.0),
        ),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          side: BorderSide(
              width: 4, color: Colors.white, style: BorderStyle.solid),
        ),
        color: Colors.grey[200], // button color
        onPressed: () async {
          setState(() {
            defaultFont = font;
          });
          await DatabaseService(id: user.id).updateUserFont(defaultFont);
        },
      ),
    );
  }
}
