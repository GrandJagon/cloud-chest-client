import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/providers/user_selection_provider.dart';
import 'package:cloud_chest/view_model/album_content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentSelectionButton extends StatelessWidget {
  void _deleteSelection(BuildContext context) async {
    // Fetching user current selection
    final List<Content> userSelection =
        Provider.of<UserSelection>(context, listen: false).userSelection;

    // Requesting the view model to delete it
    try {
      await Provider.of<AlbumContentViewModel>(context, listen: false)
          .deleteFromAlbum(userSelection)
          .then(
        (value) {
          // When done clears the user list selection object
          Provider.of<UserSelection>(context, listen: false).clearSelection();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blue,
              content: Text(
                'Deletion successfull',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building button');
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.green),
        child: Text('Delete selection'),
        onPressed: () => _deleteSelection(context),
      ),
    );
  }
}
