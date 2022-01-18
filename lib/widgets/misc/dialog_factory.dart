import 'package:cloud_chest/widgets/misc/widget_factory.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonMessage;

  CustomAlertDialog(this.title, this.message, this.buttonMessage);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
            TextButton(
                child: Text(buttonMessage),
                onPressed: () => Navigator.of(context).pop())
          ],
        ),
      ),
    );
  }
}
