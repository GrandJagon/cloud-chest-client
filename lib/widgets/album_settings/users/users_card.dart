import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/view_model/thumbnail_selection_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/users/single_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersCard extends StatefulWidget {
  @override
  State<UsersCard> createState() => _UsersCardState();
}

class _UsersCardState extends State<UsersCard> {
  void _openAddUserDialog() {
    print('ADDING USER');
  }

  // Checks whether or not the thumbnail view model has a thumbnail selected
  // Used for adapting the container size
  bool _isThumbnail(BuildContext context) {
    bool result = Provider.of<ThumbnailSelectionViewModel>(context).isSelection;
    print(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final users =
        context.read<CurrentAlbumViewModel>().currentAlbumDetail.users;

    context.watch<ThumbnailSelectionViewModel>();

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
              onPressed: () => _openAddUserDialog(),
            )
          ],
        ),
        Container(
          height: _isThumbnail(context)
              ? MediaQuery.of(context).size.height / 3.5
              : MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), border: Border.all()),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => SingleUserTile(users[index]),
          ),
        ),
      ],
    );
  }
}
