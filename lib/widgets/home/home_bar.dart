import 'package:flutter/material.dart';
import 'package:cloud_chest/widgets/albums/create_album_dialog.dart';

class HomeBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50);

  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My albums'),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => print('showing drawer'),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => showDialog(
              context: context, builder: (context) => CreateAlbumDialog()),
        )
      ],
    );
  }
}
