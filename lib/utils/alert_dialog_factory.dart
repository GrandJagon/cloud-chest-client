import 'package:flutter/material.dart';

// Factory class to provide alert dialogs depending on the situation
class AlertDialogFactory {
  // Alert dialog with one button that will push a named replacement when clicked
  static Widget oneButtonDialog(
      BuildContext context, String message, String buttonMessage,
      [String? routeName]) {
    return AlertDialog(
      title: Text('Error'),
      content: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height / 4,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(message),
              TextButton(
                child: Text(buttonMessage),
                onPressed: () {
                  routeName != null
                      ? Navigator.of(context).pushReplacementNamed(routeName)
                      : Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
