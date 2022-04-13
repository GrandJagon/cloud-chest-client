import 'package:cloud_chest/widgets/auth/auth_card.dart';
import 'package:cloud_chest/widgets/auth/forgot_password_dialog/forgot_password_dialog.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static final routeName = '/authScreen';

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ForgotPasswordDialog(),
    );
  }

  Widget build(BuildContext context) {
    double _bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: _bottomInset > 0 ? 0 : 50),
            AuthCard(),
            SizedBox(
              height: 30,
            ),
            TextButton(
              child: Text(
                'Forgot my password',
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () => _showForgotPasswordDialog(context),
            )
          ],
        ),
      ),
    ));
  }
}
