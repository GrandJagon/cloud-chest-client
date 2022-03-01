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
  FocusNode _focusNode = FocusNode();
  bool _isThumbnail = false;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<CurrentAlbumViewModel>(context, listen: false);

    // Adding a listener to the focus node
    // Every time the user finishes typing something in the title text field
    // Corresponding value in view model is updated
    _focusNode.addListener(
      () {
        if (!_focusNode.hasFocus) {
          viewModel.updateDetails('title', _titleController.text);
        }
      },
    );

    album = viewModel.currentAlbumDetail;

    _isThumbnail = (album.thumbnail != '');
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  // Opens the album in dialog mode to choose a thumbnail from the pictures
  void _openThumbnailSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => ThumbnailSelectionDialog(album.albumId, _setThumbnail),
    ).then((value) {
      // Clears the temp selection on exit
      Provider.of<ThumbnailSelectionViewModel>(context, listen: false)
          .clearTemp();
    });
  }

  // Called from thumbnail dialog selection to pass the chosen thumbnail up
  void _setThumbnail(String path) async {
    Provider.of<ThumbnailSelectionViewModel>(context, listen: false)
        .validateSelection();

    // Updates the state
    viewModel.updateDetails('thumbnail', path);

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
              focusNode: _focusNode,
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
                    ? _buildThumbnail(album.thumbnail, context)
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
