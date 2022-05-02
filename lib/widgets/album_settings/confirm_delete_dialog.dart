import 'dart:ui';
import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;

  ConfirmDeleteDialog(this.title);

  // Pops the dialogs and passes true to parent in order to delete album
  void _confirmDeletion(BuildContext context) {
    Navigator.pop(context, true);
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
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.headline2,
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
