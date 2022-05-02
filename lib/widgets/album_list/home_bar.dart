import 'package:cloud_chest/screens/account/account_screen.dart';
import 'package:cloud_chest/view_model/album_list/album_list_view_model.dart';
import 'package:cloud_chest/widgets/album_list/new_album_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50);

  void _showNewAlbumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NewAlbumDialog(),
    ).then(
      (value) {
        if (value != null) _createAlbum(context, value);
      },
    );
  }

  Future<void> _createAlbum(BuildContext context, String title) async {
    try {
      await Provider.of<AlbumListViewModel>(context, listen: false)
          .createAlbum(title);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            err.toString(),
          ),
        ),
      );
    }
  }

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
            onPressed: () => _showNewAlbumDialog(context))
      ],
    );
  }
}
