import 'package:cloud_chest/models/content/content.dart';
import 'package:cloud_chest/view_model/content_viewer_view_model.dart';
import 'package:cloud_chest/screens/album_content/album_content_screen.dart';
import 'package:cloud_chest/utils/alert_dialog_factory.dart';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentViewerBar extends StatelessWidget {
  void _deleteButton(BuildContext context) {
    // Fecthes currently displayed content
    final Content _currentContent =
        Provider.of<ContentViewerViewModel>(context, listen: false).currentItem;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialogFactory.twoButtonsDialog(
        ctx,
        'Delete content',
        'Are you sure you want to delete this content ?',
        'Delete',
        'Go back',
        () => Provider.of<CurrentAlbumViewModel>(context, listen: false)
            .deleteFromAlbum(
          [_currentContent],
        ).then(
          (value) => Navigator.popUntil(
            context,
            ModalRoute.withName(AlbumContentScreen.routeName),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            alignment: Alignment.bottomLeft,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            alignment: Alignment.bottomRight,
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.white,
            ),
            onPressed: () => _deleteButton(context),
          ),
        ],
      ),
    );
  }
}
