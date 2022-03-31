import 'package:cloud_chest/screens/account/account_screen.dart';
import 'package:cloud_chest/widgets/album_list/new_album_dialog.dart';
import 'package:flutter/material.dart';

class HomeBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50);

  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My albums'),
      leading: IconButton(
        icon: Icon(
          Icons.perm_identity,
          size: 30,
        ),
        onPressed: () =>
            Navigator.of(context).pushNamed(AccountScreen.routeName),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => showDialog(
              context: context, builder: (context) => NewAlbumDialog()),
        )
      ],
    );
  }
}
