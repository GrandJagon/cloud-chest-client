import 'package:cloud_chest/view_model/thumbnail_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmThumbnailSelection extends StatefulWidget {
  late final Function onPressFunction;

  ConfirmThumbnailSelection(this.onPressFunction);

  @override
  State<ConfirmThumbnailSelection> createState() =>
      _ConfirmThumbnailSelectionState();
}

class _ConfirmThumbnailSelectionState extends State<ConfirmThumbnailSelection> {
  late ThumbnailSelectionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ThumbnailSelectionViewModel>();
    return Container(
      width: double.infinity,
      height: viewModel.isSelection ? 50 : 0,
      color: Colors.green,
      child: TextButton(
        child: Center(child: Text('Select thumbnail')),
        onPressed: () => widget.onPressFunction,
      ),
    );
  }
}
