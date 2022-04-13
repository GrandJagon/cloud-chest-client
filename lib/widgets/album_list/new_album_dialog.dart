import 'dart:ui';

import 'package:cloud_chest/view_model/album_list/album_list_view_model.dart';
import 'package:cloud_chest/widgets/misc/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewAlbumDialog extends StatefulWidget {
  @override
  State createState() => _NewAlbumDialogState();
}

class _NewAlbumDialogState extends State<NewAlbumDialog> {
  TextEditingController _controller = TextEditingController(text: 'My album');

  Future<void> _createAlbum() async {
    try {
      await Provider.of<AlbumListViewModel>(context, listen: false)
          .createAlbum(_controller.text)
          .then(
            (value) => Navigator.of(context).pop(),
          );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            err.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    Center(
                      child: Text(
                        'New album',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      controller: _controller,
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
            _createButton(context, () => _createAlbum())
          ],
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context, Function onPress) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.green,
      child: TextButton(
        child: Text(
          'Create album',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        onPressed: () => onPress(),
      ),
    );
  }
}
