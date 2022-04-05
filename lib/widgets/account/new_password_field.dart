import 'package:flutter/material.dart';

class NewPasswordField extends StatefulWidget {
  final String password;

  NewPasswordField(this.password);

  @override
  State<NewPasswordField> createState() => _NewPasswordFieldState();
}

class _NewPasswordFieldState extends State<NewPasswordField> {
  bool _isHidden = true;

  String _passwordDisplay() {
    if (!_isHidden) return widget.password;

    return ("*" * widget.password.length);
  }

  void _toggleShowPassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'New password :',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _passwordDisplay(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:
                              _isHidden ? FontWeight.bold : FontWeight.normal,
                          fontSize: _isHidden ? 22 : 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Listener(
                onPointerDown: (details) => _toggleShowPassword(),
                onPointerUp: (details) => _toggleShowPassword(),
                child: Icon(Icons.visibility_outlined),
              )
            ],
          )
        ],
      ),
    );
  }
}
