import 'package:cloud_chest/models/right.dart';
import 'package:cloud_chest/view_model/content/content_selection_view_model.dart';
import 'package:cloud_chest/view_model/content/current_album_content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ACTION_TYPE { DOWNLOAD, DELETE }

class ContentSelectionButton extends StatefulWidget {
  @override
  _ContentSelectionButtonState createState() => _ContentSelectionButtonState();
}

class _ContentSelectionButtonState extends State<ContentSelectionButton> {
  late ContentSelectionViewModel userSelection;
  late CurrentAlbumViewModel currentAlbum;
  bool _hidden = false;

  // Main function that will be called when any of the two buttons are pressed
  Future<void> _onPress(BuildContext context, ACTION_TYPE actionType) async {
    // Updates state to hide the widget
    setState(() {
      _hidden = true;
    });

    // Calls the appropriate function given the button that was pressed on
    try {
      if (actionType == ACTION_TYPE.DELETE) {
        await _deleteSelection(context);
      }
      if (actionType == ACTION_TYPE.DOWNLOAD) {
        await _downloadSelection(context);
      }

      // Clears the selection
      Provider.of<ContentSelectionViewModel>(context, listen: false)
          .clearSelection();
    } catch (e) {
      // Displays a snackbar given the action type requested
      var message;
      if (actionType == ACTION_TYPE.DELETE) message = 'Deletion failed';
      if (actionType == ACTION_TYPE.DOWNLOAD) message = 'Download failed';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 600),
          backgroundColor: Colors.red,
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    setState(() {
      _hidden = false;
    });
  }

  Future<void> _deleteSelection(BuildContext context) async {
    // Requesting the view model to delete the user selection
    await Provider.of<CurrentAlbumViewModel>(context, listen: false)
        .deleteFromAlbum(userSelection.userSelection)
        .then(
      (value) {
        // When done clears the user list selection object
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 600),
            backgroundColor: Colors.green,
            content: Text(
              'Deletion successfull',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadSelection(BuildContext context) async {
    // Requesting the view model to delete it
    await Provider.of<CurrentAlbumViewModel>(context, listen: false)
        .downloadFromAlbum(userSelection.userSelection)
        .then(
      (value) {
        // When done clears the user list selection object
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 600),
            backgroundColor: Colors.green,
            content: Text(
              'Download successful',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  // Chek if user has deleting right in order to display the proper buttons
  bool _canDelete() {
    return (currentAlbum.hasRight(AdminRight) ||
        currentAlbum.hasRight(DeleteRight));
  }

  @override
  Widget build(BuildContext context) {
    // Fetching user current selection
    userSelection = context.watch<ContentSelectionViewModel>();
    currentAlbum = context.read<CurrentAlbumViewModel>();

    return Container(
      height: userSelection.length > 0 && !_hidden ? 50 : 0,
      width: double.infinity,
      color: Colors.black38,
      child: Row(
        mainAxisAlignment: _canDelete()
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _onPress(context, ACTION_TYPE.DOWNLOAD),
          ),
          _canDelete()
              ? IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () => _onPress(context, ACTION_TYPE.DELETE),
                )
              : Container()
        ],
      ),
    );
  }
}
