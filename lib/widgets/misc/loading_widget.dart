import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Colors.blue),
    );
  }
}
