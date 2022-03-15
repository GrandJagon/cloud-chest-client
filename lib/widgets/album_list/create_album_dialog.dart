import 'dart:ui';
import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/album_list_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CreateAlbumDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateAlbumDialogState();
}

class _CreateAlbumDialogState extends State<CreateAlbumDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _albumInfos = {'title': ''};

  Future<void> _submitForm(BuildContext context) async {
    _formKey.currentState!.save();

    try {
      await Provider.of<AlbumListViewModel>(context, listen: false)
          .createAlbum(_albumInfos['title']!, _albumInfos['description'])
          .then(
            (value) => Navigator.of(context).pop(),
          );
    } on Exception catch (err) {
      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final AlbumListViewModel albumListViewModel =
        context.watch<AlbumListViewModel>();
    double _bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Dialog(
          insetPadding: _bottomInset > 0
              ? EdgeInsets.fromLTRB(40, 0, 40, 24)
              : EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          elevation: 8,
          child: albumListViewModel.response.status == ResponseStatus.LOADING
              ? LoadingWidget()
              : _buildForm(_bottomInset)),
    );
  }

  _buildForm(double bottomInset) {
    return Form(
      key: _formKey,
      child: Container(
        height: MediaQuery.of(context).size.height / 1.9,
        padding: EdgeInsets.all(12),
        alignment: FractionalOffset.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Create a new album',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: bottomInset > 0 ? 0 : 12,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Album title'),
                onSaved: (newValue) => _albumInfos['title'] = newValue!,
              ),
              TextButton(
                child: Text(
                  'Create',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
