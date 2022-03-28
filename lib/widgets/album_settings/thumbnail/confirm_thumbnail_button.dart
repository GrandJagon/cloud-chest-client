import 'package:cloud_chest/view_model/album_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmThumbnailButton extends StatefulWidget {
  late final Function(String) onPressFunction;

  ConfirmThumbnailButton(this.onPressFunction);

  @override
  State<ConfirmThumbnailButton> createState() => _ConfirmThumbnailButtonState();
}

class _ConfirmThumbnailButtonState extends State<ConfirmThumbnailButton> {
  late AlbumSettingsViewModel viewModel;

  // Fetches the user selection from the view model and passes it to parent through onPressFunction()
  void _onPress() {
    String path = Provider.of<AlbumSettingsViewModel>(context, listen: false)
        .thumbnailTemp!;

    widget.onPressFunction(path);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<AlbumSettingsViewModel>();
    return Container(
      width: double.infinity,
      height: viewModel.isThumbnailTemp ? 50 : 0,
      color: Colors.green,
      child: TextButton(
        child: Center(
          child: Text(
            'Select thumbnail',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: () => _onPress(),
      ),
    );
  }
}
