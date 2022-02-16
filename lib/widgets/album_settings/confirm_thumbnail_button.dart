import 'dart:html';

import 'package:flutter/material.dart';

class ConfirmThumbnailSelection extends StatelessWidget {
  late final Function onPressFunction;

  ConfirmThumbnailSelection(this.onPressFunction);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.green,
      child: TextButton(
        child: Center(child: Text('Select thumbnail')),
        onPressed: () => onPressFunction,
      ),
    );
  }
}
