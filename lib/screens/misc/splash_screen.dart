import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: LoadingWidget(),
      ),
    );
  }
}
