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

  // Function to be called whenver a selection is confirmed to be sent to parent
  void _confirmSelection() {
    return;
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
              itemBuilder: (ctx, i) =>
                  ThumbnailSelectionItem(viewModel.contentList[i]),
            ),
          ),
          ConfirmThumbnailSelection(() => _confirmSelection())
        ],
      ),
    );
  }
}
