import 'package:flutter/material.dart';

// Factory class to provide alert dialogs depending on the situation
class AlertDialogFactory {
  // Alert dialog with one button that will push a named replacement when clicked
  static Widget oneButtonDialog(
      BuildContext context, String title, String message, String buttonMessage,
      [String? routeName]) {
    return AlertDialog(
      title: Text(title),
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

  static Widget twoButtonsDialog(
      BuildContext context,
      String title,
      String message,
      String okMessage,
      String notOkMessage,
      Function okFunction) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height / 4,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(message),
              TextButton(
                child: Text(okMessage),
                onPressed: () => okFunction(),
              ),
              TextButton(
                child: Text(notOkMessage),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
