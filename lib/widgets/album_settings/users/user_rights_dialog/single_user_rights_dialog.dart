import 'dart:ui';
import 'package:cloud_chest/models/right.dart';
import 'package:cloud_chest/view_model/album_settings_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/users/user_rights_dialog/right_selection_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/user.dart';

class SingleUserRightsDialog extends StatelessWidget {
  final int userIndex;
  late final AlbumSettingsViewModel vm;
  late final User user;
  final List<String> newRights = ['content:read'];

  SingleUserRightsDialog(this.userIndex);

  // Called from children each time the right selection button is ticked
  void toggleRight(String right) {
    if (newRights.contains(right)) {
      print('REMOVING ' + right);
      newRights.remove(right);
    } else {
      print('ADDING ' + right);
      newRights.add(right);
    }
  }

  void _onValidate(BuildContext context) {
    print('CALLING VALIDATION');
    vm.updateUserRights(userIndex, newRights);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    vm = context.read<AlbumSettingsViewModel>();
    user = vm.users![userIndex];
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
                children: user.hasRight(AdminRight)
                    ? [
                        RightSelectionRow('Admin', 'admin', toggleRight,
                            user.hasRight(AdminRight)),
                        _validateButton(context, _onValidate)
                      ]
                    : [
                        RightSelectionRow(
                          'Can view content',
                          'content:read',
                          toggleRight,
                          user.hasRight(ViewRight),
                        ),
                        RightSelectionRow(
                          'Can post content',
                          'content:add',
                          toggleRight,
                          user.hasRight(PostRight),
                        ),
                        RightSelectionRow(
                          'Can delete content',
                          'content:delete',
                          toggleRight,
                          user.hasRight(DeleteRight),
                        ),
                        _validateButton(context, _onValidate)
                      ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _validateButton(BuildContext context, Function onPress) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: TextButton(
      onPressed: () => onPress(context),
      child: Text(
        'Validate',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
