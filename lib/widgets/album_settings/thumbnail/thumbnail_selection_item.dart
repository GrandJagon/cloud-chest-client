import 'package:cloud_chest/view_model/thumbnail_selection_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:provider/provider.dart';

class ThumbnailSelectionItem extends StatefulWidget {
  final Content item;

  // Index needed for the hero animation, key nedded for keeping state when items deletion
  ThumbnailSelectionItem(this.item);

  Content getItem() => item;

  @override
  State<StatefulWidget> createState() => ThumbnailSelectionItemState();
}

class ThumbnailSelectionItemState extends State<ThumbnailSelectionItem> {
  bool _isSelected = false;
  late ThumbnailSelectionViewModel viewModel;

  // Remove listener on disposal
  @override
  void dispose() {
    try {
      viewModel.removeListener(_onNewSelectionCallBack);
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  // Callback to be registered within listener whenever the widget is selected
  // Allows to undraw borders from view model
  void _onNewSelectionCallBack() {
    if (viewModel.tempSelection != widget.item) {
      setState(
        () {
          _isSelected = false;
        },
      );
      viewModel.removeListener(_onNewSelectionCallBack);
    }
  }

  // To be called when widget is pressed
  // Sets or remove the corresponding item to the view model
  void _toggleSelected() {
    if (viewModel.tempSelection != widget.item) {
      setState(() {
        _isSelected = true;
      });
      viewModel.setOrRemove(widget.item);
      // Adds a listener to unselect whenever an other object is selected
      viewModel.addListener(_onNewSelectionCallBack);
    } else {
      setState(() {
        _isSelected = false;
      });
      viewModel.setOrRemove(widget.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.read<ThumbnailSelectionViewModel>();
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _toggleSelected(),
      child: Container(
        height: _isSelected ? size.height / 3 : size.height / 4,
        width: _isSelected ? size.width / 3 : size.width / 4,
        decoration: BoxDecoration(
          border:
              _isSelected ? Border.all(color: Colors.green, width: 3) : null,
        ),
        child: Hero(
          tag: widget.item.id,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            placeholder: (ctx, url) => LoadingWidget(),
            imageUrl: widget.item.path,
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
