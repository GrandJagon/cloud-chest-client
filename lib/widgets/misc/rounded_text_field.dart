import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function? onFieldSubmitted;
  final TextInputType keyboardType;
  final bool obscure;

  RoundedTextField(
      {this.controller,
      this.focusNode,
      this.onFieldSubmitted,
      this.keyboardType = TextInputType.text,
      this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscure,
        focusNode: focusNode,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
        ),
        controller: controller,
        onFieldSubmitted: onFieldSubmitted != null
            ? (value) => onFieldSubmitted!.call()
            : (value) => {},
      ),
    );
  }
}
