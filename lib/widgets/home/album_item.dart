import 'package:cloud_chest/providers/album_provider.dart';
import 'package:cloud_chest/screens/album_detail/album_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class AlbumItem extends StatelessWidget {
  final String id;

  AlbumItem(this.id);

  LinearGradient _randomGradient() {
    return LinearGradient(colors: [
      Color(Random().nextInt(0xffffffff)),
      Color(Random().nextInt(0xffffffff))
    ], begin: Alignment.topLeft, end: Alignment.bottomRight);
  }

  Widget _titleContainer(String title) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.white60,
      child: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget build(BuildContext context) {
    final album = Provider.of<AlbumProvider>(context, listen: false)
        .getAlbumById(this.id);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(AlbumDetailScreen.routeName, arguments: album),
      child: Card(
        elevation: 8,
        child: Container(
          clipBehavior: Clip.antiAlias,
          height: size.height / 6,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: album.thumbnail == '' ? _randomGradient() : null,
          ),
          child: Stack(
            children: <Widget>[
              album.thumbnail != ''
                  ? AspectRatio(
                      aspectRatio: 3,
                      child: Image.network(
                        album.thumbnail,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : SizedBox.shrink(),
              Center(child: _titleContainer(album.title))
            ],
          ),
        ),
      ),
    );
  }
}
