import 'package:flutter/material.dart';

class EmptyListView {
//If list of data is Empty set Empty Widget with image
  Widget buildEmptyListView(Color color, String title, String subtitle) =>
      Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40),
            ),
            title == "No favorite jet..."
                ? Container(
                    height: 240,
                    width: 240,
                    child: Icon(
                      Icons.insert_drive_file,
                      size: 100,
                      color: color,
                    ),
                  )
                : Container(
                    height: 240,
                    width: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: Icon(
                      Icons.perm_identity,
                      size: 100,
                      color: color,
                    ),
                  ),
            Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 26.0,
                  fontFamily: 'FredokaOne',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 24.0,
                  fontFamily: 'FredokaOne',
                ),
              ),
            )
          ],
        ),
      );
}
