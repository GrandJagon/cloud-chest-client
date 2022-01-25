import 'package:cloud_chest/providers/auth_provider.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/widgets/home/album_list_view.dart';
import 'package:cloud_chest/widgets/home/home_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screen that displays all albums to which the user has access
class HomeScreen extends StatelessWidget {
  static final routeName = '/home';

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
