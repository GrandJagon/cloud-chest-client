import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendButton extends StatefulWidget {
  TextEditingController controller;

  SendButton(this.controller);

  @override
  _SendButtonState createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  bool _hidden = true;

  @override
  void initState() {
    widget.controller.addListener(() {
      print('listener fired');
      if (widget.controller.text.length < 1) _hidden = true;
      if (widget.controller.text.length == 1) _hidden = false;

      setState(() {});
    });
  }

  Future<void> _resetPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      setState(() {
        _hidden = true;
      });
      await Provider.of<AccountSettingsViewModel>(context, listen: false)
          .resetPassword(widget.controller.text)
          .then(
            (value) => Navigator.of(context).pop(),
          );
    } catch (e, stack) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _hidden ? 0 : 50,
      color: Colors.blue,
      child: TextButton(
        child: Center(
          child: Text(
            'Send',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: () => _resetPassword(context),
      ),
    );
  }
}
