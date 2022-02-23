import 'package:cloud_chest/widgets/album_settings/edit_settings_card.dart';
import 'package:flutter/material.dart';

class AlbumSettingScreen extends StatelessWidget {
  static final String routeName = '/albumSettings';
  bool _isInit = false;
  String? albumId;

  // Fetches the album ID in the route arguments the first time it's built
  void _fetchArgument(BuildContext context) {
    albumId = ModalRoute.of(context)!.settings.arguments as String;
    _isInit = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) _fetchArgument(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Album settings'),
      ),
      body: Column(
        children: <Widget>[EditSettingsForm(albumId!)],
      ),
    );
  }
}
