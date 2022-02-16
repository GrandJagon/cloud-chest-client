import 'package:cloud_chest/view_model/album_content_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:provider/provider.dart';

class ThumbnailSelectionItem extends StatefulWidget {
  final Content item;
  final Function toggleConfirmButton;

  // Index needed for the hero animation, key nedded for keeping state when items deletion
  ThumbnailSelectionItem(this.item, this.toggleConfirmButton);

  @override
  State<StatefulWidget> createState() => _ThumbnailSelectionItemState();
}

class _ThumbnailSelectionItemState extends State<ThumbnailSelectionItem> {
  bool _isSelected = false;

  // To be called when item is long pressed in order to select it
  // Can later take action on the selection
  void _selectItem() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _selectItem(),
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
