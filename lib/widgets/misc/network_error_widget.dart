import 'package:flutter/material.dart';

// Widget to be displayed when there is a network error and data can't be fetched
// Contains an icon and a retry button to which the function should be passed
class NetworkErrorWidget extends StatelessWidget {
  final Function _retry;
  final String? _errorMessage;

  NetworkErrorWidget(this._retry, [this._errorMessage]);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_errorMessage != null)
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        Icon(
          Icons.sentiment_very_dissatisfied_outlined,
          color: Colors.red,
          size: 50,
        ),
        TextButton(
          child: Text(
            'Retry',
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
          onPressed: () => _retry(),
        )
      ],
    ));
  }
}
