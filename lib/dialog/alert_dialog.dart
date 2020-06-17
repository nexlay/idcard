import 'package:flutter/material.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/screens/favorites.dart';

import 'flushbar.dart';

class DialogPopUp {
  final FlushBar _flushBar = FlushBar();
  //Alert Dialog
  Widget buildAlertDialog(BuildContext context, int color, String id,
      String token, String title, String content, int flag) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      actions: [
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: flag == 4
              ? Text(
                  'Later',
                  style: TextStyle(
                    color: Color(color),
                  ),
                )
              : Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(color),
                  ),
                ),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          onPressed: () async {
            if (flag == 1) {
              await DatabaseService(id: id).setUserData(false, 4278228616, '',
                  '', '', '', '', '', '', '', '', '', '', '', '');
              await DatabaseService(id: id).deleteFavoriteUser(token);
              Navigator.pop(context);
              _flushBar.flushBar(context, 'All data was deleted', 'Hide',
                  Colors.white, Colors.black, true);
              return;
            } else if (flag == 2) {
              await DatabaseService(id: id).updateUserPrivacy(true);
              Navigator.pop(context);
              _flushBar.flushBar(context, 'Data shared successfully', 'Hide',
                  Colors.white, Colors.black, true);
            } else if (flag == 3) {
              await DatabaseService(id: id).updateUserPrivacy(false);
              Navigator.pop(context);
              _flushBar.flushBar(context, 'Data hide successfully', 'Hide',
                  Colors.white, Colors.black, true);
            } else if (flag == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favorites(
                    color: Color(color),
                  ),
                ),
              );
            } else if (flag == 5) {
              Navigator.pop(context);
              await DatabaseService(id: id).deleteFavoriteUser(token);
              return;
            }
          },
          child: flag == 4
              ? Text(
                  'Show',
                  style: TextStyle(
                    color: Color(color),
                  ),
                )
              : Text(
                  'OK',
                  style: TextStyle(
                    color: Color(color),
                  ),
                ),
        )
      ],
    );
  }
}
