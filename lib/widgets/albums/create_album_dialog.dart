import 'dart:io';

import 'package:cloud_chest/providers/album_provider.dart';
import 'package:cloud_chest/utils/alert_dialog_factory.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CreateAlbumDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateAlbumDialogState();
}

class _CreateAlbumDialogState extends State<CreateAlbumDialog> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _albumInfos = {'title': '', 'description': ''};

  Future<void> _submitForm(BuildContext context) async {
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AlbumProvider>(context, listen: false)
          .createAlbum(_albumInfos['title']!, _albumInfos['description']!)
          .then((value) => Navigator.of(context).pop());
    } on Exception catch (err) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialogFactory.oneButtonDialog(ctx, err.toString(), 'OK'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      child: _isLoading
          ? LoadingWidget()
          : Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.3,
                alignment: FractionalOffset.center,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Create a new album',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Album title'),
                      onSaved: (newValue) => _albumInfos['title'] = newValue!,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 3,
                      decoration:
                          const InputDecoration(labelText: 'Album description'),
                      onSaved: (newValue) =>
                          _albumInfos['description'] = newValue!,
                    ),
                    TextButton(
                      child: Text(
                        'Create',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      onPressed: () => _submitForm(context),
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
