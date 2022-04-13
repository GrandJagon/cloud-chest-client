import 'dart:ui';
import 'package:cloud_chest/widgets/auth/forgot_password_dialog/forgot_password_form.dart';
import 'package:cloud_chest/widgets/auth/forgot_password_dialog/send_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            ForgotPasswordForm(_controller),
            SendButton(_controller)
          ],
        ),
      ),
    );
  }
}
