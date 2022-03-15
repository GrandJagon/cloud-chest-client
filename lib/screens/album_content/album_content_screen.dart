import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/album.dart';
import 'package:cloud_chest/screens/misc/splash_screen.dart';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/widgets/album_content/content_grid.dart';
import 'package:cloud_chest/widgets/album_content/album_content_bar.dart';
import 'package:cloud_chest/widgets/album_content/content_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumContentScreen extends StatefulWidget {
  static final routeName = '/albumContent';

  @override
  State<AlbumContentScreen> createState() => _AlbumContentScreenState();
}

class _AlbumContentScreenState extends State<AlbumContentScreen> {
  late final Album album;
  late CurrentAlbumViewModel vm;

  @override
  Widget build(BuildContext context) {
    vm = context.watch<CurrentAlbumViewModel>();

    if (vm.response.status == ResponseStatus.LOADING)
      return SplashScreen();
    else
      return _buildScreen(context);
  }

  Widget _buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AlbumContentBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ContentGrid(),
          ),
          ContentSelectionButton()
        ],
      ),
    );
  }
}
