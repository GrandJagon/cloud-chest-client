import 'package:cloud_chest/screens/auth/connect_screen.dart';
import 'package:cloud_chest/widgets/misc/widget_factory.dart';
import 'package:flutter/material.dart';

// Widget to be displayed when there is a network error and data can't be fetched
// Contains an icon and a retry button to which the function should be passed
class NetworkErrorWidget extends StatelessWidget {
  final Function? retryCallback;
  final String? message;
  final bool changeConfig;

  NetworkErrorWidget(
      {this.retryCallback = null,
      this.message = null,
      this.changeConfig = false});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (message != null)
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Text(
              message!,
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        Icon(
          Icons.sentiment_very_dissatisfied_outlined,
          color: Colors.red,
          size: 50,
        ),
        retryCallback == null
            ? Container()
            : TextButton(
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                onPressed: () => retryCallback!(),
              ),
        !changeConfig
            ? Container()
            : TextButton(
                child: Text(
                  'Change config',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                onPressed: () => Navigator.of(context)
                    .popAndPushNamed(ConnectScreen.routeName),
              )
      ],
    ));
  }
}
