import 'dart:ui';

import 'package:cloud_chest/models/factories/right_icon_factory.dart';
import 'package:cloud_chest/widgets/album_settings/users/user_rights_dialog/right_selection_row.dart';
import 'package:flutter/material.dart';

import '../../../../models/user.dart';

class SingleUserRightsDialog extends StatelessWidget {
  final User user;

  SingleUserRightsDialog(this.user);

  void _onValidate() {
    // RIGHTS VALIDATION LOGIC
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                user.email,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 20,
              ),
              ListView(
                shrinkWrap: true,
                children: user.isAdmin()
                    ? [
                        RightSelectionRow(
                          'Admin',
                          RightIconFactory.createIcon('admin'),
                        ),
                        _validateButton(_onValidate)
                      ]
                    : [
                        RightSelectionRow(
                          'Can view content',
                          RightIconFactory.createIcon('content:read'),
                        ),
                        RightSelectionRow(
                          'Can post content',
                          RightIconFactory.createIcon('content:add'),
                        ),
                        RightSelectionRow(
                          'Can delete content',
                          RightIconFactory.createIcon('content:delete'),
                        ),
                        _validateButton(_onValidate)
                      ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _validateButton(Function onPress) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: TextButton(
      onPressed: () => onPress,
      child: Text(
        'Validate',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
