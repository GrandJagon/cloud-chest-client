import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cloud_chest/widgets/misc/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordForm extends StatefulWidget {
  final TextEditingController controller;

  ForgotPasswordForm(this.controller);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  late AccountSettingsViewModel vm;

  @override
  Widget build(BuildContext context) {
    vm = context.watch<AccountSettingsViewModel>();

    if (vm.response.status == ResponseStatus.LOADING_PARTIAL)
      return LoadingWidget();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            Text(
              "Please enter the email address with which you registered.\nWe will reset your password and send you a temporary one in order for you to login and choose a new one.",
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 20,
            ),
            RoundedTextField(
              controller: widget.controller,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email address',
            ),
          ],
        ),
      ),
    );
  }
}
