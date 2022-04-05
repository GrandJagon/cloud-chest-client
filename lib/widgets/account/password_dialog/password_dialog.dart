import 'dart:ui';

import 'package:cloud_chest/view_model/account/change_password_view_model.dart';
import 'package:cloud_chest/widgets/account/password_dialog/save_password_button.dart';
import 'package:cloud_chest/widgets/misc/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordDialog extends StatefulWidget {
  @override
  State createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final FocusNode _confirmFocusNode = FocusNode();
  late final ChangePasswordViewModel vm;

  @override
  void initState() {
    vm = context.read<ChangePasswordViewModel>();

    _passwordController.addListener(
      () => _textFieldListener(context, 'password', _passwordController),
    );
    _confirmController.addListener(
      () => _textFieldListener(context, 'confirm', _confirmController),
    );
  }

  // Whenever one of the filed change callback is fired
  void _textFieldListener(
      BuildContext context, String field, TextEditingController caller) {
    vm.setValue(field, caller.text);
  }

  // Function to be called when first text field loses focus
  void goNextField(BuildContext context) {
    FocusScope.of(context).requestFocus(_confirmFocusNode);
  }

  String? _validate() {
    if (!vm.isData()) return 'Password cannot be null';
    if (!vm.areSame()) return 'Passwords must be the same';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Password :',
                        style: TextStyle(fontSize: 20),
                      ),
                      RoundedTextField(
                        controller: _passwordController,
                        onValidation: () => _validate(),
                        onFieldSubmitted: () => goNextField(context),
                        obscure: true,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Confirm password :',
                        style: TextStyle(fontSize: 20),
                      ),
                      RoundedTextField(
                        controller: _confirmController,
                        onValidation: () => _validate(),
                        focusNode: _confirmFocusNode,
                        obscure: true,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SavePasswordButton(_formKey)
          ],
        ),
      ),
    );
  }
}
