import 'package:cloud_chest/models/album.dart';
import 'package:cloud_chest/view_model/albums_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/thumbnail_card.dart';
import 'package:cloud_chest/widgets/album_settings/thumbnail_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSettingsForm extends StatefulWidget {
  final String albumId;

  EditSettingsForm(this.albumId);

  @override
  State<EditSettingsForm> createState() => _EditSettingsCardState();
}

class _EditSettingsCardState extends State<EditSettingsForm> {
  late Album album;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _thumbnailController = TextEditingController();
  bool _isThumbnail = false;
  final _newSettings = {'title': '', 'thumbnail': ''};

  @override
  void initState() {
    super.initState();

    album = Provider.of<AlbumsViewModel>(context, listen: false)
        .getAlbumById(widget.albumId);

    _isThumbnail = (album.thumbnail != '');
  }

  // Opens the album in dialog mode to choose a thumbnail from the pictures
  void _openThumbnailSelection(BuildContext context) {
    showDialog(
        context: context,
        builder: (c) => ThumbnailSelectionDialog(album.albumId, _setTumbnail));
  }

  // Called from thumbnail dialog selection to pass the chosen thumbnail up
  void _setTumbnail(String path) async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(controller: _titleController..text = album.title),
            SizedBox(
              height: 50,
            ),
            _isThumbnail
                ? ThumbnailCard(album.thumbnail)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('This album does not have a thumbnail'),
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
