import 'package:cloud_chest/view_model/album_settings/album_settings_view_model.dart';
import 'package:cloud_chest/view_model/album_settings/user_search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ValidateButton extends StatefulWidget {
  @override
  State<ValidateButton> createState() => _ValidateButtonState();
}

class _ValidateButtonState extends State<ValidateButton> {
  late UserSearchViewModel selection;
  late AlbumSettingsViewModel vm;

  void _onPress(BuildContext context) {
    try {
      vm.addNewUser(selection.user);
    } on Exception catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text(
            err.toString(),
          ),
        ),
      );
    }

    selection.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    selection = context.watch<UserSearchViewModel>();
    vm = context.read<AlbumSettingsViewModel>();
    return Container(
      width: double.infinity,
      color: Colors.green,
      height: selection.hasSelection ? 50 : 0,
      child: TextButton(
        child: Text(
          'Add',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _onPress(context),
      ),
    );
  }
}
