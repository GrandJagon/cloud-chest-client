import 'package:flutter/material.dart';

class ContentViewerBar extends StatelessWidget with PreferredSizeWidget {
  final Function showMetaData;

  // Function to be passed from content viewer
  ContentViewerBar(this.showMetaData);

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.cancel_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.preview_rounded),
          onPressed: () => this.showMetaData(),
        )
      ],
    );
  }
}
