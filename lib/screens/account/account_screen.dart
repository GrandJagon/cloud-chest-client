import 'package:cloud_chest/widgets/account/account_settings_form.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  static String routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account settings'),
      ),
      body: AccountSettingsForm(),
    );
  }
}
