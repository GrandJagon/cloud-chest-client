import 'package:cloud_chest/models/album.dart';
import 'package:cloud_chest/providers/auth_provider.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/screens/content/content_viewer.dart';
import 'package:cloud_chest/widgets/album_detail/album_detail_bar.dart';
import 'package:cloud_chest/widgets/content/content_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumDetailScreen extends StatelessWidget {
  static final routeName = '/albumDetail';

  @override
  Widget build(BuildContext context) {
    // Checking auth in order to redirect to auth screen if not
    if (!Provider.of<AuthProvider>(context, listen: false).isAuth)
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    final album = ModalRoute.of(context)!.settings.arguments as Album;

    return Scaffold(
      appBar: AlbumDetailBar(album.albumId, album.title),
      body: Stack(
        children: <Widget>[ContentGrid(album.albumId)],
      ),
    );
  }
}
