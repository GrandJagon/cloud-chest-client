import 'package:cloud_chest/widgets/auth/auth_card.dart';
import 'package:cloud_chest/widgets/auth/auth_logo.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static final routeName = '/authScreen';

  Widget build(BuildContext context) {
    double _bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AuthLogo(),
            SizedBox(height: _bottomInset > 0 ? 0 : 50),
            AuthCard(),
          ],
        ),
      ),
    ));
  }
}
