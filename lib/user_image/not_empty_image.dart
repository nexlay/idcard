import 'package:flutter/material.dart';
import 'package:idcard/custom/loading.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/user.dart';
import 'file:///D:/flutter_projects/idcard/lib/user_image/user_image_picker.dart';
import 'package:provider/provider.dart';

class UserImage extends StatelessWidget {
  final double radius;

  UserImage(this.radius);

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
          return _buildAvatar(context, userData, radius);
        } else {
          return Loading();
        }
      },
    );
  }

  //User image picked with image_picker
  Widget _buildAvatar(BuildContext context, UserData userData, double radius) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: CircleAvatar(
          backgroundImage: userData.image != null
              ? NetworkImage(userData.image)
              : Container(),
          radius: radius,
          backgroundColor: userData.color.toString().isNotEmpty
              ? Color(userData.color)
              : defaultColor,
          child: radius == 50.0
              ? GestureDetector(
                  onTap: () {
                    _userImagePicker.filePicker(context, userData);
                  },
                )
              : GestureDetector(),
        ),
      );
}
