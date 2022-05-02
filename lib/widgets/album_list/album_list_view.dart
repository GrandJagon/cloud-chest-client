import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/album_list/album_list_view_model.dart';
import 'package:cloud_chest/view_model/auth/auth_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/auth/auth_screen.dart';
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
    Future.delayed(
      Duration.zero,
      () =>
          Provider.of<AlbumListViewModel>(context, listen: false).fetchAlbums(),
    );
  }

  // To be called if access is unauthorized in order to be redirected to login page
  Future<void> _logout() async {
    await Provider.of<Auth>(context, listen: false).logout().then(
          (value) => Navigator.of(context).pushNamedAndRemoveUntil(
            AuthScreen.routeName,
            (Route<dynamic> route) => false,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    AlbumListViewModel albumListViewModel = context.watch<AlbumListViewModel>();
    if (albumListViewModel.response.status == ResponseStatus.LOADING_FULL)
      return LoadingWidget();
    if (albumListViewModel.response.status == ResponseStatus.ERROR)
      return NetworkErrorWidget(
        retryCallback: () => albumListViewModel.fetchAlbums(),
        message: albumListViewModel.response.message,
      );
    if (albumListViewModel.response.status == ResponseStatus.UNAUTHORIZED) {
      albumListViewModel.resetResponse();
      _logout();
    }
    return _buildAlbumGrid(albumListViewModel.albumList);
  }
}

_buildAlbumGrid(List albums) {
  print(albums.toList());
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
