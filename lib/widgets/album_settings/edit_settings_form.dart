import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/album.dart';
import 'package:cloud_chest/models/album_detail.dart';
import 'package:cloud_chest/view_model/album_list_view_model.dart';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/view_model/thumbnail_selection_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/thumbnail/thumbnail_selection_dialog.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSettingsForm extends StatefulWidget {
  EditSettingsForm();

  @override
  State<EditSettingsForm> createState() => _EditSettingsFormState();
}

class _EditSettingsFormState extends State<EditSettingsForm> {
  late AlbumDetail album;
  late CurrentAlbumViewModel viewModel;
  TextEditingController _titleController = TextEditingController();
  bool _isThumbnail = false;
  final _newSettings = {'title': '', 'thumbnail': ''};

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<CurrentAlbumViewModel>(context, listen: false);

    album = viewModel.currentAlbumDetail;

    _isThumbnail = (album.thumbnail != '');
  }

  // Opens the album in dialog mode to choose a thumbnail from the pictures
  void _openThumbnailSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => ThumbnailSelectionDialog(album.albumId, _setTumbnail),
    ).then((value) {
      // Clears the selection on exit
      Provider.of<ThumbnailSelectionViewModel>(context, listen: false).clear();
    });
  }

  // Called from thumbnail dialog selection to pass the chosen thumbnail up
  void _setTumbnail(String path) async {
    _newSettings['title'] = _titleController.text;
    _newSettings['thumbnail'] = path;

    try {
      setState(() {
        _isThumbnail = true;
      });
    } catch (e, stack) {
      print(stack);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _titleController..text = album.title,
              validator: (value) {
                if (value!.length <= 0) return 'Title must not be null';
                return null;
              },
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _isThumbnail
                    ? _buildThumbnail(_newSettings['thumbnail']!, context)
                    : Text('This album does not have a thumbnail'),
                IconButton(
                  onPressed: () => _openThumbnailSelection(context),
                  icon: Icon(Icons.add_a_photo),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildThumbnail(String path, BuildContext context) {
  return Container(
    width: 200,
    height: 200,
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: path,
      placeholder: (url, context) => LoadingWidget(),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: Colors.red,
      ),
    ),
  );
}
