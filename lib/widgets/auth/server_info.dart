import 'package:cloud_chest/screens/auth/connect_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/config_helper.dart';

class ServerInfo extends StatelessWidget {
  final String _host = Config().get('host');
  final String _port = Config().get('port');

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Host :',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(_host),
          Text(
            'Port :',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(_port),
          IconButton(
              icon: Icon(Icons.build_sharp, size: 16),
              onPressed: () =>
                  Navigator.of(context).pushNamed(ConnectScreen.routeName))
        ],
      ),
    );
  }
}
