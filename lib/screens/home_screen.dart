import 'package:cloud_chest/widgets/home/album_list.dart';
import 'package:cloud_chest/widgets/home/home_bar.dart';
import 'package:flutter/material.dart';

// Screen that displays all albums to which the user has access
class HomeScreen extends StatelessWidget {
  static final routeName = '/home';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(),
      body: Container(
        padding: EdgeInsets.all(15),
        child: AlbumList(),
      ),
    );
  }
}
