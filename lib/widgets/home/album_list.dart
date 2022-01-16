import 'dart:io';
import 'package:cloud_chest/utils/alert_dialog_factory.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/providers/album_provider.dart';
import 'package:provider/provider.dart';
import 'album_item.dart';
import 'package:cloud_chest/widgets/misc/network_error_widget.dart';

class AlbumList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  bool _isLoading = false;
  bool _isInit = false;
  bool _isError = false;

  @override
  Future<void> didChangeDependencies() async {
    _fetchAlbums(context);
    super.didChangeDependencies();
  }

  // Makes a call to the API to fetch the albums
  Future<void> _fetchAlbums(BuildContext context) async {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });

      try {
        print('fetching albums');
        await Provider.of<AlbumProvider>(context, listen: false)
            .fetchAndSetAlbums()
            .then((value) {
          setState(() {
            _isLoading = false;
            _isInit = true;
            _isError = false;
          });
        });
      } on Exception catch (err) {
        print(err);
        setState(() {
          _isInit = false;
          _isLoading = false;
          _isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final albums = Provider.of<AlbumProvider>(context).albums;

    if (_isLoading) return LoadingWidget();
    if (_isError)
      return NetworkErrorWidget(
        () => _fetchAlbums(context),
        'The server is not responding. Make sure it is up and running',
      );
    if (_isInit && !_isError)
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
                  itemBuilder: (ctx, i) => AlbumItem(albums[i].albumId),
                ));
    else
      return Container();
  }
}
