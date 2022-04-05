import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:cloud_chest/widgets/account/account_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static String routeName = '/account';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  late AccountSettingsViewModel vm;

  @override
  void initState() {
    vm = context.read<AccountSettingsViewModel>();
    Future.delayed(
      Duration.zero,
      () => vm.fetchUserDetails().then(
        (value) {
          mailController.text = vm.userDetails['email']!;
          usernameController.text = vm.userDetails['username']!;
        },
      ),
    );
    super.initState();
  }

  // Save the changes and propagate them to the API
  void _saveChanges(BuildContext context) async {
    if (mailController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email must not be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newDetails = {
      'email': mailController.text,
      'username': usernameController.text
    };

    if (vm.newPassword != null) newDetails['password'] = vm.newPassword!;

    await Provider.of<AccountSettingsViewModel>(context, listen: false)
        .updateUserDetails(newDetails)
        .then((value) => Navigator.of(context).pop())
        .catchError(
          (err) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                err.toString(),
              ),
              backgroundColor: Colors.red,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<AccountSettingsViewModel>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Account settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: AccountSettingsForm(
              mailController,
              usernameController,
            ),
          ),
          _saveButton(
            () => _saveChanges(context),
          )
        ],
      ),
    );
  }

  Widget _saveButton(Function onPress) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.black38,
      child: TextButton(
        onPressed: () => onPress(),
        child: Text(
          'Save changes',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
