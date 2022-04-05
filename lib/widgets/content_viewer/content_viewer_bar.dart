import 'package:cloud_chest/models/content/content.dart';
import 'package:cloud_chest/models/right.dart';
import 'package:cloud_chest/view_model/content/content_viewer_view_model.dart';
import 'package:cloud_chest/view_model/content/current_album_content_view_model.dart';
import 'package:cloud_chest/widgets/content_viewer/confirm_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentViewerBar extends StatelessWidget {
  late CurrentAlbumViewModel vm;

  void _deleteContent(BuildContext context) {
    // Fecthes currently displayed content
    final Content _currentContent =
        Provider.of<ContentViewerViewModel>(context, listen: false).currentItem;

    showDialog(
      context: context,
      builder: (ctx) => ConfirmDeleteDialog(_currentContent),
    );
  }

  @override
  Widget build(BuildContext context) {
    vm = context.read<CurrentAlbumViewModel>();
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
          _deleteButton(context)
        ],
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return (vm.hasRight(AdminRight) || vm.hasRight(DeleteRight))
        ? IconButton(
            alignment: Alignment.bottomRight,
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.white,
            ),
            onPressed: () => _deleteContent(context),
          )
        : Container();
  }
}
