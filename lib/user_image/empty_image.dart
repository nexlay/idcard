import 'package:flutter/material.dart';
import 'package:idcard/custom/loading.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/user.dart';
import 'package:idcard/user_image/user_image_picker.dart';
import 'package:provider/provider.dart';

class EmptyUserImage extends StatelessWidget {
  final double radius;
  final Icon icon;

  EmptyUserImage(this.radius, this.icon);

  final UserImagePicker _userImagePicker = UserImagePicker();

  //A default color of the screen
  final Color defaultColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(id: user.id).userData,
      builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return _buildAvatar(context, userData, radius, icon);
        } else {
          return Loading();
        }
      },
    );
  }

//User image picked with image_picker
  Widget _buildAvatar(
          BuildContext context, UserData userData, double radius, Icon icon) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: CircleAvatar(
          radius: radius,
          backgroundColor:
              userData.color != null ? Color(userData.color) : defaultColor,
          child: IconButton(
            onPressed: () async {
              _userImagePicker.filePicker(context, userData);
            },
            icon: icon,
          ),
        ),
      );
}
