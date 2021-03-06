import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/models/content/album.dart';
import 'package:cloud_chest/screens/album_content/album_content_screen.dart';
import 'package:cloud_chest/view_model/auth/auth_view_model.dart';
import 'package:cloud_chest/view_model/content/current_album_content_view_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class AlbumItem extends StatelessWidget {
  final Album album;

  AlbumItem(this.album);

  // Random gradient for background if no thumbnail
  LinearGradient _randomGradient() {
    return LinearGradient(
      colors: [
        Color(Random().nextInt(0xffffffff)),
        Color(Random().nextInt(0xffffffff))
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Album title styling
  Widget _titleContainer(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.black38,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  // Initiates the view model with the chosen album and pushes the route
  Future<void> _openAlbumContent(BuildContext context) async {
    Provider.of<CurrentAlbumViewModel>(context, listen: false)
        .setCurrentAlbumRights(album.rights);

    Provider.of<CurrentAlbumViewModel>(context, listen: false)
        .fetchSingleAlbum(album.albumId);

    Navigator.of(context)
        .pushNamed(AlbumContentScreen.routeName, arguments: album);
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _openAlbumContent(context),
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
                  ? Container(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        httpHeaders: {'auth-token': Auth().accessToken!},
                        placeholder: (context, url) => Container(),
                        imageUrl: album.thumbnail,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : SizedBox.shrink(),
              Center(child: _titleContainer(context, album.title))
            ],
          ),
        ),
      ),
    );
  }
}
