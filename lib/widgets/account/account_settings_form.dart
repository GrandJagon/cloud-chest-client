import 'package:flutter/material.dart';

class AccountSettingsForm extends StatefulWidget {
  @override
  _AccountSettingsFormState createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  TextEditingController _mailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _buildTextField(_mailController, 'TEST')
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String? initialValue) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            isCollapsed: true,
          ),
        ),
      ),
    );
  }
}
