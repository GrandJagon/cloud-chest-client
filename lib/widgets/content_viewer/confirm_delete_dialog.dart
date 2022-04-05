import 'dart:ui';

import 'package:cloud_chest/screens/album_content/album_content_screen.dart';
import 'package:cloud_chest/view_model/content/current_album_content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/content/content.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final Content content;

  ConfirmDeleteDialog(this.content);

  void _deleteContent(BuildContext context) {
    Provider.of<CurrentAlbumViewModel>(context, listen: false).deleteFromAlbum(
      [content],
    ).then(
      (value) => Navigator.popUntil(
        context,
        ModalRoute.withName(AlbumContentScreen.routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Are you sure you want to delete this content ?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            _deleteButton(context)
          ],
        ),
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.red,
      child: Center(
        child: TextButton(
          child: Text(
            'Delete',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          onPressed: () => _deleteContent(context),
        ),
      ),
    );
  }
}
