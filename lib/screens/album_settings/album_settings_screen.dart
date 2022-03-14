import 'package:cloud_chest/models/album_settings.dart';
import 'package:cloud_chest/view_model/album_list_view_model.dart';
import 'package:cloud_chest/view_model/album_settings_view_model.dart';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/users/users_card.dart';
import 'package:cloud_chest/widgets/album_settings/edit_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumSettingScreen extends StatelessWidget {
  static final String routeName = '/albumSettings';

  // Saving user changes to album settings and making api call
  void _saveChanges(BuildContext context) async {
    try {
      // Creates albumSettings object from user settings values
      AlbumSettings newSettings =
          Provider.of<AlbumSettingsViewModel>(context, listen: false)
              .generateSetting();

      // Sends them to the new model
      await Provider.of<CurrentAlbumViewModel>(context, listen: false)
          .validateSettings(newSettings);

      // Propagates the new settings to the album list in order to update item in list
      Provider.of<AlbumListViewModel>(context, listen: false).updateAlbum(
          newSettings.albumId, newSettings.title, newSettings.thumbnail);

      _exit(context);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occured while updating',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteAlbum() {
    print('deleting');
  }

  // Called whenver leaving the page to clear the thumbnail selection state
  void _exit(BuildContext context) {
    Provider.of<AlbumSettingsViewModel>(context, listen: false).clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => _exit(context),
        ),
        title: Text('Album settings'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () => _deleteAlbum(),
          )
        ],
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
          _buildValidateButton(
            () => _saveChanges(context),
          )
        ],
      ),
    );
  }
}

Widget _buildValidateButton(Function onPress) {
  return Container(
    height: 50,
    width: double.infinity,
    color: Colors.blue,
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
