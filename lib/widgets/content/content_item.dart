import 'package:cloud_chest/providers/content_provider_old.dart';
import 'package:cloud_chest/screens/content/content_viewer.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:provider/provider.dart';

class ContentItem extends StatefulWidget {
  final Content item;
  final List selectedItems;

  ContentItem(this.item, this.selectedItems);

  @override
  State<StatefulWidget> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem> {
  bool _isSelected = false;
  bool _isInit = false;
  late final int itemIndex;

  @override
  void initState() {
    super.initState();
    // TO IMPLEMENT A DB CHECK TO SEE IF FILE IS ALREADY IN LOCAL MEMORY
    // IF SO FETCH IT FROM STORAGE IN ORDER TO AVOIR MAKING USELESS CALL TO API
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      itemIndex = Provider.of<ContentProvider>(context, listen: false)
          .getContentIndex(widget.item);
    }
  }

  // To be called when item is long pressed in order to select it
  // Can later take action on the selection
  void _selectItem() {
    setState(() {
      _isSelected = !_isSelected;
    });

    // SHOULD REPLACE PATH WITH AN ID AN CREATE A GETTER IN THE PROVIDER TO AVOID COMPLEXIFICATION
    switch (_isSelected) {
      case true:
        widget.selectedItems.add(widget.item.path);
        break;
      case false:
        widget.selectedItems.remove(widget.item.path);
        break;
    }
  }

  // Display the content viewer, pass the current item index in order for the viewer to be able to go forward or backward in the album
  void _showViewer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ContentViewer(itemIndex),
    );
  }

  // If no item already selected display the viewer, if there is already items in the selection add to it
  void _onTap(BuildContext context) {
    widget.selectedItems.length <= 0 ? _showViewer(context) : _selectItem();
  }

  // If no item already selected add it to selecton
  void _longPress() {
    if (widget.selectedItems.length <= 0) _selectItem();
  }

  @override
  Widget build(BuildContext context) {
    print('building content item');
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () => _longPress(),
      onTap: () => _onTap(context),
      child: Container(
        height: _isSelected ? size.height / 3 : size.height / 4,
        width: _isSelected ? size.width / 3 : size.width / 4,
        decoration: BoxDecoration(
          border:
              _isSelected ? Border.all(color: Colors.orange, width: 3) : null,
        ),
        child: Hero(
          tag: itemIndex,
          child: CachedNetworkImage(
            placeholder: (ctx, url) => LoadingWidget(),
            imageUrl: widget.item.path,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
