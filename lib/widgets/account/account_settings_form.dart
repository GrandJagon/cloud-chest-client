import 'package:cloud_chest/view_model/account_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSettingsForm extends StatefulWidget {
  final String email;
  final String username;

  AccountSettingsForm(this.email, this.username);

  @override
  _AccountSettingsFormState createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  TextEditingController _mailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mailController.text = widget.email;
    _usernameController.text = widget.username;
  }

  void _deleteAccount() {
    print('deleting');
  }

  void _saveChanges(BuildContext context) async {
    if (_mailController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email must not be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newDetails = {
      'email': _mailController.text,
      'username': _usernameController.text
    };

    await Provider.of<AccountSettingsViewModel>(context, listen: false)
        .updateUserDetails(newDetails)
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update successfull'),
              backgroundColor: Colors.green,
            ),
          ),
        )
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
                    _buildTextField(_mailController),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Username :',
                        style: Theme.of(context).textTheme.headline2),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(_usernameController),
                    SizedBox(
                      height: 50,
                    ),
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
          _saveButton(
            () => _saveChanges(context),
          )
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
