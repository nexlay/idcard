import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idcard/database/database.dart';
import 'package:idcard/models/user.dart';
import 'package:path/path.dart' as path;

class UserImagePicker {
  //File picker to pick DB file with a data created by User
  String fileType = 'image';
  String fileName;
  File file;

  Future filePicker(BuildContext context, UserData userData) async {
    try {
      file = await FilePicker.getFile(type: FileType.image);

      fileName = path.basename(file.path);

      DatabaseService(id: userData.id).uploadFile(file, fileName);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
