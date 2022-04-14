import 'dart:ui';

import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountDialog extends StatefulWidget {
  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  late AccountSettingsViewModel vm;

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      await Provider.of<AccountSettingsViewModel>(context, listen: false)
          .deleteAccount()
          .whenComplete(
            () => Navigator.of(context).pushNamedAndRemoveUntil(
              AuthScreen.routeName,
              (Route<dynamic> route) => false,
            ),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<AccountSettingsViewModel>();

    if (vm.response.status == ResponseStatus.LOADING_FULL)
      return LoadingWidget();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Are you sure you want to delete your account ? \nAny album and content will be lost forever.',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(20),
                color: Colors.red,
                height: 50,
                width: 200,
                child: TextButton(
                  child: Text(
                    'Delete anyway',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  onPressed: () => _deleteAccount(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
