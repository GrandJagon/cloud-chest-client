import 'dart:io';
import 'package:cloud_chest/view_model/content/content_viewer_view_model.dart';
import 'package:cloud_chest/view_model/content/content_selection_view_model.dart';
import 'package:cloud_chest/screens/content_viewer/content_viewer_screen.dart';
import 'package:cloud_chest/view_model/content/current_album_content_view_model.dart';
import 'package:cloud_chest/widgets/album_content/content_item/picture_thumbnail.dart';
import 'package:cloud_chest/widgets/album_content/content_item/video_thumbnail.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/models/content/content.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../models/content/picture.dart';
import '../../../models/content/video.dart';

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
  late CurrentAlbumViewModel viewModel;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();

    // Fired whenever the item object has its state toggled
    widget.item.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.item.cancelSubscription();
    super.dispose();
  }

  // To be called when item is long pressed in order to select it
  // Can later take action on the selection
  void _selectItem() {
    widget.item.toggleSelected();
    Provider.of<ContentSelectionViewModel>(context, listen: false)
        .addOrRemove(widget.item);
  }

  // Sets the content viewer starting point as widget.id and pushes content viewert
  void _showViewer(BuildContext context) {
    Provider.of<ContentViewerViewModel>(context, listen: false)
        .setStartingPoint(widget.index);
    Navigator.of(context).pushNamed(ContentViewerScreen.routeName);
  }

  // If no item already selected display the viewer, if there is already items in the selection add to it
  void _onTap(BuildContext context) {
    Provider.of<ContentSelectionViewModel>(context, listen: false).length <= 0
        ? _showViewer(context)
        : _selectItem();
  }

  // If no item already selected add it to selecton
  void _longPress() {
    if (Provider.of<ContentSelectionViewModel>(context, listen: false).length <=
        0) _selectItem();
  }

  @override
  Widget build(BuildContext context) {
    _isSelected = widget.item.isSelected();

    // viewModel = context.read<CurrentAlbumViewModel>();
    Size size = MediaQuery.of(context).size;
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
          child: Opacity(
            opacity: widget.item.isDownloading() ? 0.5 : 1,
            child: _buildThumbnail(context),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    if (widget.item is Picture) return PictureThumbnail(widget.item);
    return Container();
  }
}