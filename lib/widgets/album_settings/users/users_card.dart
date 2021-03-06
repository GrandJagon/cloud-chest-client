import 'package:cloud_chest/view_model/album_settings/album_settings_view_model.dart';
import 'package:cloud_chest/view_model/album_settings/user_search_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/users/find_user_dialog/find_user_dialog.dart';
import 'package:cloud_chest/widgets/album_settings/users/single_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersCard extends StatefulWidget {
  @override
  State<UsersCard> createState() => _UsersCardState();
}

class _UsersCardState extends State<UsersCard> {
  // Called when add button is pressed
  // On exit response of view model will be reset to done
  void _openAddUserDialog(BuildContext context) {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (c) => FindUserDialog(),
    ).then(
      (value) {
        Provider.of<UserSearchViewModel>(context, listen: false).clear();
      },
    );
  }

  // Checks whether or not the thumbnail view model has a thumbnail selected
  // Used for adapting the container size
  bool _isThumbnail(BuildContext context) {
    bool result = Provider.of<AlbumSettingsViewModel>(context).isThumbnail;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final users = context.watch<AlbumSettingsViewModel>().users;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
            ),
            Text(
              'Users',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.1,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _openAddUserDialog(context),
            )
          ],
        ),
        Container(
          height: _isThumbnail(context)
              ? MediaQuery.of(context).size.height / 4
              : MediaQuery.of(context).size.height / 2.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), border: Border.all()),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: users!.length,
            itemBuilder: (context, index) => SingleUserTile(index),
          ),
        ),
      ],
    );
  }
}
