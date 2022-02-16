import 'package:cloud_chest/widgets/album_settings/edit_settings_card.dart';
import 'package:flutter/material.dart';

class AlbumSettingScreen extends StatelessWidget {
  final String albumId;

  AlbumSettingScreen(this.albumId);

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
        children: <Widget>[EditSettingsForm(albumId)],
      ),
    );
  }
}
