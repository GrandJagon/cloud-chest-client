import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/providers/content_viewer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MetadataPane extends StatefulWidget {
  @override
  State<MetadataPane> createState() => _MetadataPaneState();
}

class _MetadataPaneState extends State<MetadataPane> {
  bool _isDeployed = false;

  @override
  Widget build(BuildContext context) {
    final content = Provider.of<ContentViewerProvider>(context).currentItem;

    // For widget starting state only the header of the bottom sheet is needed
    // Content is displayed when button is clicked and _showMetadata() called
    return _paneHeader(content);
  }

  void _hideMetadata() {
    _isDeployed = false;
    Navigator.of(context).pop();
  }

  // Holds the pane header and the pane content
  _showMetadata(Content content) {
    _isDeployed = true;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      context: context,
      builder: (context) {
        return _paneHeader(content);
      },
    ).whenComplete(() => _isDeployed = false);
  }

  // Part of the widget that will always be the same besides the icon button function changing
  Widget _paneHeader(Content content) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  content.storageDate,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () =>
                      _isDeployed ? _hideMetadata() : _showMetadata(content),
                )
              ],
            ),
            Divider(
              color: Colors.white,
              indent: 50,
              endIndent: 50,
            )
          ],
        ),
      ),
    );
  }
}
