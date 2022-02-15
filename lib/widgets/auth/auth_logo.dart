import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black26, offset: Offset(2, 0))
        ],
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Text(
        'LOGO',
        style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white),
      ),
    );
  }
}
