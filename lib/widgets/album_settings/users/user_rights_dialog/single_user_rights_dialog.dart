import 'dart:ui';
import 'package:cloud_chest/models/right.dart';
import 'package:cloud_chest/view_model/album_settings/album_settings_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/users/user_rights_dialog/right_selection_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/user.dart';

class SingleUserRightsDialog extends StatelessWidget {
  final int userIndex;
  late final AlbumSettingsViewModel vm;
  late final User user;
  late final List<String> rights;
  bool _isInit = false;

  SingleUserRightsDialog(this.userIndex);

  // Fetches this particular user rights from the view model
  void _fetchRights() {
    rights = user.getRightValues();
    _isInit = true;
  }

  // Called from children each time the right selection button is ticked
  void toggleRight(String right) {
    if (rights.contains(right)) {
      rights.remove(right);
    } else {
      rights.add(right);
    }
  }

  void _onValidate(BuildContext context) {
    vm.updateUserRights(userIndex, rights);
    Navigator.of(context).pop();
  }

  void _removeUser(BuildContext context) {
    vm.removeUser(userIndex);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    vm = context.read<AlbumSettingsViewModel>();
    user = vm.users![userIndex];
    if (!_isInit) _fetchRights();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.email,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                            ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      child: Text(
                        'Remove user',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => _removeUser(context),
                    )
                  ],
                ),
              ),
            ),
            _validateButton(context, _onValidate)
          ],
        ),
      ),
    );
  }

  Widget _validateButton(BuildContext context, Function onPress) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.green,
      child: TextButton(
        child: Center(
          child: Text(
            'Validate',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
          ),
        ),
        onPressed: () => onPress(context),
      ),
    );
  }
}
