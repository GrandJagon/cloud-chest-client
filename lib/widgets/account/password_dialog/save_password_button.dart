import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:cloud_chest/view_model/account/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavePasswordButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  SavePasswordButton(this.formKey);

  @override
  State createState() => _SavePasswordButtonState();
}

class _SavePasswordButtonState extends State<SavePasswordButton> {
  late ChangePasswordViewModel vm;

  // Validation check and send new passord to API
  void _savePasswords() {
    FocusScope.of(context).unfocus();

    final FormState form = widget.formKey.currentState!;

    if (!form.validate()) return;

    Provider.of<AccountSettingsViewModel>(context, listen: false)
        .setNewPassword(vm.data['password']!);

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
