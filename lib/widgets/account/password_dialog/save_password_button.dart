import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:cloud_chest/view_model/account/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavePasswordButton extends StatefulWidget {
  @override
  State createState() => _SavePasswordButtonState();
}

class _SavePasswordButtonState extends State<SavePasswordButton> {
  late ChangePasswordViewModel vm;

  // Validation check and send new passord to API
  void _savePasswords() {
    FocusScope.of(context).unfocus();

    if (!vm.isData()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
          ),
          content: Text(
            'A value must be provider',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!vm.areSame()) {
      print('snackba');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
          ),
          content: Text(
            'Passwords are not the same',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Provider.of<AccountSettingsViewModel>(context, listen: false).newPassword =
        vm.data['password'];

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<ChangePasswordViewModel>();

    return Container(
      width: double.infinity,
      height: vm.isButtonVBisible ? 50 : 0,
      color: Colors.green,
      child: TextButton(
        child: Text(
          'Change password',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _savePasswords(),
      ),
    );
  }
}
