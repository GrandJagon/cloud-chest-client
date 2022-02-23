import 'package:cloud_chest/models/album.dart';
import 'package:cloud_chest/providers/auth_provider.dart';
import 'package:cloud_chest/view_model/user_selection_view_model.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/widgets/album_content/content_grid.dart';
import 'package:cloud_chest/widgets/album_content/album_content_bar.dart';
import 'package:cloud_chest/widgets/album_content/content_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumContentScreen extends StatelessWidget {
  static final routeName = '/albumContent';

  @override
  Widget build(BuildContext context) {
    // Checking auth in order to redirect to auth screen if not
    if (!Provider.of<Auth>(context, listen: false).isConnected)
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    final album = ModalRoute.of(context)!.settings.arguments as Album;

    print('Building screen');

    return Scaffold(
      appBar: AlbumContentBar(album.albumId, album.title),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ContentGrid(album.albumId),
          ),
          ContentSelectionButton()
        ],
      ),
    );
  }
}
