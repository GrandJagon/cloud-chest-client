import 'package:cloud_chest/models/album.dart';
import 'package:cloud_chest/widgets/album_detail/album_detail_bar.dart';
import 'package:cloud_chest/widgets/album_detail/files_grid.dart';
import 'package:flutter/material.dart';

class AlbumDetailScreen extends StatelessWidget {
  static final routeName = '/albumDetail';

  @override
  Widget build(BuildContext context) {
    final album = ModalRoute.of(context)!.settings.arguments as Album;

    return Scaffold(
      appBar: AlbumDetailBar(album.albumId, album.title),
      body: FilesGrid(album.albumId),
    );
  }
}
