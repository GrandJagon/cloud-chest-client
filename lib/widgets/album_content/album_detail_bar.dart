import 'package:cloud_chest/view_model/album_content_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumContentBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final String id;
  final ImagePicker _picker = ImagePicker();

  AlbumContentBar(this.id, this.title);

  @override
  Size get preferredSize => Size.fromHeight(50);

  // Allows user to select images from gallery to upload them on the server
  Future<void> _uploadFromGallery(BuildContext context) async {
    try {
      final pictures = await _picker.pickMultiImage();

      if (pictures == null) return;

      final paths = pictures.map((e) => e.path).toList();

      await _uploadFiles(paths, context);
    } catch (err, stack) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Upload unsuccessfull',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Sends the files to the provider which makes an API call
  Future<void> _uploadFiles(List<String> files, BuildContext context) async {
    await Provider.of<AlbumContentViewModel>(context, listen: false)
        .uploadToAlbum(files);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => print('Album settings'),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _uploadFromGallery(context),
        )
      ],
    );
  }
}
