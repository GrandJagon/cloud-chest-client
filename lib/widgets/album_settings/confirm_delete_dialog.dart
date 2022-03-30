import 'dart:ui';

import 'package:cloud_chest/screens/albums_list/albums_list_screen.dart';
import 'package:cloud_chest/view_model/album_list/album_list_view_model.dart';
import 'package:cloud_chest/widgets/album_list/album_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String id;

  ConfirmDeleteDialog(this.title, this.id);

  Future<void> _confirmDeletion(BuildContext context) async {
    try {
      await Provider.of<AlbumListViewModel>(context, listen: false)
          .deleteAlbum(id)
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, AlbumsListScreen.routeName, (route) => false);
      });
    } on Exception catch (err) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Are you sure you want to delete the album ' + title + ' ?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 70,
              ),
              TextButton(
                onPressed: () => _confirmDeletion(context),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
