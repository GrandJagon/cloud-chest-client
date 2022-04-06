import 'package:cloud_chest/models/right.dart';
import 'package:cloud_chest/screens/album_settings/album_settings_screen.dart';
import 'package:cloud_chest/view_model/content/current_album_content_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumContentBar extends StatelessWidget with PreferredSizeWidget {
  final ImagePicker _picker = ImagePicker();
  late final CurrentAlbumViewModel vm;

  AlbumContentBar();

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

  Future<void> _pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.media, allowMultiple: true);

      if (result == null) return;

      final List<String> paths = List.from(result.paths);

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
    await Provider.of<CurrentAlbumViewModel>(context, listen: false)
        .uploadToAlbum(files);
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<CurrentAlbumViewModel>();
    return AppBar(
      title: Text(vm.currentAlbumSettings.title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        _settingsButton(context),
        _addButton(context),
      ],
    );
  }

  Widget _settingsButton(BuildContext context) {
    return vm.hasRight(AdminRight)
        ? IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed(
                AlbumSettingScreen.routeName,
                arguments: vm.currentAlbumSettings.albumId),
          )
        : Container();
  }

  Widget _addButton(BuildContext context) {
    return (vm.hasRight(AdminRight) || vm.hasRight(PostRight))
        ? IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _pickFile(context),
          )
        : Container();
  }
}
