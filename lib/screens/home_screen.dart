import 'package:cloud_chest/providers/auth_provider_old.dart';
import 'package:cloud_chest/widgets/home/album_list.dart';
import 'package:cloud_chest/widgets/home/home_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_screen.dart';

// Screen that displays all albums to which the user has access
class HomeScreen extends StatelessWidget {
  static final routeName = '/home';

  Widget build(BuildContext context) {
    // Checking auth in order to redirect to auth screen if not
    if (!Provider.of<AuthProvider>(context, listen: false).isAuth)
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    return Scaffold(
        appBar: HomeBar(),
        body: Container(
          padding: EdgeInsets.all(15),
          child: AlbumList(),
        ));
  }
}
