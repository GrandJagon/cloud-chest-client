import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/album_rights_card.dart';
import 'package:cloud_chest/widgets/album_settings/edit_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumSettingScreen extends StatelessWidget {
  static final String routeName = '/albumSettings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Album settings'),
      ),
      body: Column(
        children: <Widget>[EditSettingsForm(), AlbumRightsCard()],
      ),
    );
  }
}
