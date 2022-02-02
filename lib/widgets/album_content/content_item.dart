import 'package:cloud_chest/providers/content_viewer_provider.dart';
import 'package:cloud_chest/providers/user_selection_provider.dart';
import 'package:cloud_chest/screens/content_viewer/content_viewer.dart';
import 'package:cloud_chest/view_model/album_content_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:provider/provider.dart';

class ContentItem extends StatefulWidget {
  final Content item;
  final int index;

  // Index needed for the hero animation, key nedded for keeping state when items deletion
  ContentItem(this.item, this.index, key) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem>
    with AutomaticKeepAliveClientMixin {
  bool _isSelected = false;
  late AlbumContentViewModel viewModel;

  @override
  bool get wantKeepAlive => true;

  // To be called when item is long pressed in order to select it
  // Can later take action on the selection
  void _selectItem() {
    setState(() {
      _isSelected = !_isSelected;
    });

    Provider.of<UserSelection>(context, listen: false).addOrRemove(widget.item);
  }

  // Sets the content viewer starting point as widget.id and pushes content viewert
  void _showViewer(BuildContext context) {
    Provider.of<ContentViewerProvider>(context, listen: false)
        .setStartingPoint(widget.index);
    Navigator.of(context).pushNamed(ContentViewerScreen.routeName);
  }

  // If no item already selected display the viewer, if there is already items in the selection add to it
  void _onTap(BuildContext context) {
    Provider.of<UserSelection>(context, listen: false).length <= 0
        ? _showViewer(context)
        : _selectItem();
  }

  // If no item already selected add it to selecton
  void _longPress() {
    if (Provider.of<UserSelection>(context, listen: false).length <= 0)
      _selectItem();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.read<AlbumContentViewModel>();
    Size size = MediaQuery.of(context).size;
    print('building item');
    return GestureDetector(
      onLongPress: () => _longPress(),
      onTap: () => _onTap(context),
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
