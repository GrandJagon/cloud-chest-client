import 'package:cloud_chest/view_model/thumbnail_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmThumbnailSelection extends StatefulWidget {
  late final Function(String) onPressFunction;

  ConfirmThumbnailSelection(this.onPressFunction);

  @override
  State<ConfirmThumbnailSelection> createState() =>
      _ConfirmThumbnailSelectionState();
}

class _ConfirmThumbnailSelectionState extends State<ConfirmThumbnailSelection> {
  late ThumbnailSelectionViewModel viewModel;

  // Fetches the user selection from the view model and passes it to parent through onPressFunction()
  void _onPress() {
    String path =
        Provider.of<ThumbnailSelectionViewModel>(context, listen: false)
            .selection!
            .path;

    widget.onPressFunction(path);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ThumbnailSelectionViewModel>();
    return Container(
      width: double.infinity,
      height: viewModel.isSelection ? 50 : 0,
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
