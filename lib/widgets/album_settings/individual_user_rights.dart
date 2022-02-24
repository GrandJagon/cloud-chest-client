import 'package:cloud_chest/models/user.dart';
import 'package:flutter/material.dart';

class SingleUserRights extends StatelessWidget {
  final User user;

  SingleUserRights(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              child: Text(user.username ?? user.email)),
        ],
      ),
    );
  }
}
