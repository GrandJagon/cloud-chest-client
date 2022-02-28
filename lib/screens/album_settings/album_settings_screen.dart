import 'package:cloud_chest/widgets/album_settings/users/users_card.dart';
import 'package:cloud_chest/widgets/album_settings/edit_settings_form.dart';
import 'package:flutter/material.dart';

class AlbumSettingScreen extends StatelessWidget {
  static final String routeName = '/albumSettings';

  void _saveChanges() {
    print('changes saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Album settings'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                EditSettingsForm(),
                Expanded(
                  child: UsersCard(),
                ),
              ],
            ),
          ),
          _buildValidateButton(_saveChanges)
        ],
      ),
    );
  }
}

Widget _buildValidateButton(Function onPress) {
  return Container(
    height: 50,
    width: double.infinity,
    color: Colors.green,
    child: TextButton(
      onPressed: () => onPress(),
      child: Text(
        'Save changes',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
