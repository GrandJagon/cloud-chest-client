import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/album_list_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'album_item.dart';
import 'package:cloud_chest/widgets/misc/network_error_widget.dart';

class AlbumListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView> {
  @override
  void initState() {
    super.initState();
    Provider.of<AlbumListViewModel>(context, listen: false).fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    AlbumListViewModel albumListViewModel = context.watch<AlbumListViewModel>();
    switch (albumListViewModel.response.status) {
      case (ResponseStatus.LOADING):
        return LoadingWidget();
      case (ResponseStatus.ERROR):
        return NetworkErrorWidget(
          () => albumListViewModel.fetchAlbums(),
          albumListViewModel.response.message,
        );
      case (ResponseStatus.DONE):
        return _buildAlbumGrid(albumListViewModel.albumList);
      default:
        return Container();
    }
  }

  _buildAlbumGrid(List albums) {
    return Container(
      child: albums.length <= 0
          ? Center(
              child: Text(
                'You have no album yet...',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: albums.length,
              itemBuilder: (ctx, i) => AlbumItem(albums[i]),
            ),
    );
  }
}
