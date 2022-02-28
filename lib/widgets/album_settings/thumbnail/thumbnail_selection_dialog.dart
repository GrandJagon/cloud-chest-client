import 'dart:ui';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/thumbnail/confirm_thumbnail_button.dart';
import 'package:cloud_chest/widgets/album_settings/thumbnail/thumbnail_selection_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThumbnailSelectionDialog extends StatefulWidget {
  final String albumId;
  final Function(String) setThumbnail;

  // setThumbnail to be called once thumbnail validation is done to set it at screen level
  ThumbnailSelectionDialog(this.albumId, this.setThumbnail);

  @override
  State<ThumbnailSelectionDialog> createState() =>
      _ThumbnailSelectionDialogState();
}

class _ThumbnailSelectionDialogState extends State<ThumbnailSelectionDialog> {
  late CurrentAlbumViewModel viewModel;

  // Function to be called whenver a selection is confirmed to be sent to parent
  // Pops the dialog once done
  void _confirmSelection(String path) {
    widget.setThumbnail(path);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.read<CurrentAlbumViewModel>();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemCount: viewModel.contentList.length,
                  itemBuilder: (ctx, i) =>
                      ThumbnailSelectionItem(viewModel.contentList[i]),
                ),
              ),
              ConfirmThumbnailSelection(_confirmSelection)
            ],
          ),
        ),
      ),
    );
  }
}
