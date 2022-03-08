import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/view_model/album_settings_view_model.dart';
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
  late CurrentAlbumViewModel albumViewModel;
  late AlbumSettingsViewModel settingsViewModel;
  TextEditingController _titleController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    albumViewModel = Provider.of<CurrentAlbumViewModel>(context, listen: false);
    settingsViewModel =
        Provider.of<AlbumSettingsViewModel>(context, listen: false);

    // Initiating settings view model with current album settings
    settingsViewModel.initState(albumViewModel.currentAlbumSettings);
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
      builder: (c) =>
          ThumbnailSelectionDialog(settingsViewModel.id!, _setThumbnail),
    ).then((value) {
      // Clears the temp selection on exit
      Provider.of<AlbumSettingsViewModel>(context, listen: false)
          .clearThumbnailTemp();
    });
  }

  // Called from thumbnail dialog selection to pass the chosen thumbnail up
  void _setThumbnail(String path) async {
    try {
      setState(() {
        Provider.of<AlbumSettingsViewModel>(context, listen: false)
            .validateThumbnailSelection();
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
              controller: _titleController..text = settingsViewModel.title!,
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
                settingsViewModel.isThumbnail
                    ? _buildThumbnail(context)
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

  Widget _buildThumbnail(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: settingsViewModel.thumbnail!,
        placeholder: (url, context) => LoadingWidget(),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          color: Colors.red,
        ),
      ),
    );
  }
}
