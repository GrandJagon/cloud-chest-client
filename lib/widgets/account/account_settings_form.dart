import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:cloud_chest/view_model/account/change_password_view_model.dart';
import 'package:cloud_chest/widgets/account/delete_account_dialog.dart';
import 'package:cloud_chest/widgets/account/new_password_field.dart';
import 'package:cloud_chest/widgets/account/password_dialog/password_dialog.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cloud_chest/widgets/misc/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth/auth_view_model.dart';

class AccountSettingsForm extends StatefulWidget {
  final TextEditingController mailController;
  final TextEditingController usernameController;

  AccountSettingsForm(this.mailController, this.usernameController);

  @override
  _AccountSettingsFormState createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  late AccountSettingsViewModel vm;

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(),
    );
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => PasswordDialog(),
    ).then(
      (value) =>
          Provider.of<ChangePasswordViewModel>(context, listen: false).clear(),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).logout().then(
          (value) => Navigator.of(context).pushNamedAndRemoveUntil(
            AuthScreen.routeName,
            (Route<dynamic> route) => false,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<AccountSettingsViewModel>();
    if (vm.response.status == ResponseStatus.LOADING_PARTIAL ||
        vm.response.status == ResponseStatus.LOADING_FULL)
      return LoadingWidget();
    if (vm.response.status == ResponseStatus.ERROR)
      return NetworkErrorWidget(
        retryCallback: vm.fetchUserDetails,
      );
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Email address :',
                        style: Theme.of(context).textTheme.headline2),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(widget.mailController),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Username :',
                        style: Theme.of(context).textTheme.headline2),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(widget.usernameController),
                    vm.newPassword != null
                        ? NewPasswordField(vm.newPassword!)
                        : Container(),
                    SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      child: Center(
                        child: Text(
                          'Change password',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      onPressed: () => _showPasswordDialog(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      child: Center(
                        child: Text(
                          'Log out',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      onPressed: () => _logout(context),
                    ),
                    Spacer(),
                    TextButton(
                      child: Center(
                        child: Text(
                          'Delete account',
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        ),
                      ),
                      onPressed: () => _deleteAccount(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            isCollapsed: true,
          ),
        ),
      ),
    );
  }
}
