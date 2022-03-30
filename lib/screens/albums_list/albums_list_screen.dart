import 'package:cloud_chest/view_model/auth/auth_view_model.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/widgets/album_list/album_list_view.dart';
import 'package:cloud_chest/widgets/album_list/home_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screen that displays all albums to which the user has access
class AlbumsListScreen extends StatelessWidget {
  static final routeName = '/albumListScreen';

  Widget build(BuildContext context) {
    if (!Provider.of<Auth>(context, listen: false).isConnected)
      Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
    return Scaffold(
      appBar: HomeBar(),
      body: Container(
        padding: EdgeInsets.all(15),
        child: AlbumListView(),
      ),
    );
  }
}
