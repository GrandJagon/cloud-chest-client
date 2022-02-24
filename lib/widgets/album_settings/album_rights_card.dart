import 'package:flutter/material.dart';

class AlbumRightsCard extends StatefulWidget {
  final String albumId;

  AlbumRightsCard(this.albumId);

  @override
  State<AlbumRightsCard> createState() => _AlbumRightsCardState();
}

class _AlbumRightsCardState extends State<AlbumRightsCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Users',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.black12),
          margin: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
              )
            ],
          ),
        ),
      ],
    );
  }
}
