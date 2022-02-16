import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/view_model/album_content_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/confirm_thumbnail_button.dart';
import 'package:cloud_chest/widgets/album_settings/thumbnail_selection_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThumbnailSelectionDialog extends StatefulWidget {
  final String albumId;
  final Function setThumbnail;

  // setThumbnail to be called once thumbnail validation is done to set it at screen level
  ThumbnailSelectionDialog(this.albumId, this.setThumbnail);

  @override
  State<ThumbnailSelectionDialog> createState() =>
      _ThumbnailSelectionDialogState();
}

class _ThumbnailSelectionDialogState extends State<ThumbnailSelectionDialog> {
  late AlbumContentViewModel viewModel;
  bool _isSelection = false;
  Content? _currentSelection;

  // Called from ThumbnailSelectionItem
  // Sets the current item and toggles confirm button
  void _selectItem(Content item) {
    // If the item passed by the item widget is the same as the one already stored then user has unselected it
    if (_currentSelection == item) {
      _currentSelection = null;
      setState(() {
        _isSelection = false;
      });
    } else {
      _currentSelection = item;

      // If _isSelection equals false then state must be updated to display the confirm button
      if (_isSelection == false) {
        setState(() {
          _isSelection = true;
        });
      }
    }
  }

  // Called when thumbnail selection is confirmed
  void _confirmSelection() {
    String path = _currentSelection!.path;

    widget.setThumbnail(path);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.read<AlbumContentViewModel>();

    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: viewModel.contentList.length,
              itemBuilder: (ctx, i) => ThumbnailSelectionItem(
                  viewModel.contentList[i], () => _selectItem),
            ),
          ),
          if (_isSelection) ConfirmThumbnailSelection(_confirmSelection),
        ],
      ),
    );
  }
}
