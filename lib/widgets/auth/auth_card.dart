import 'dart:async';
import 'dart:io';
import 'package:cloud_chest/providers/auth_provider.dart';
import 'package:cloud_chest/screens/albums_list/albums_list_screen.dart';
import 'package:cloud_chest/utils/alert_dialog_factory.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../misc/loading_widget.dart';
import 'package:cloud_chest/widgets/auth/server_info.dart';

enum AuthMode { Login, Signup }

class AuthCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthCardState();
  }
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  var _credentials = {'email': '', 'password': ''};
  var _isLoading = false;
  var _validationError = '';
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;

  // Setting all the animation variables
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 290),
      end: Size(double.infinity, 350),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _heightAnimation.addListener(() => setState(() {}));
  }

  // Dispose of the animation controller
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Switches to login or signup
  void _toggleAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.Signup;
        _controller.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller.reverse();
      }
    });
  }

  // Called on save to store the field value in the credentials that will be send to the server
  // Validation made server-side
  void _saveField(String fieldName, String? value) {
    if (value == null) value = '';
    _credentials[fieldName] = value;
    print(_credentials);
  }

  // Try to validate the form and in case of non validation displays the validation error as snackbar
  bool _validate() {
    _formKey.currentState!.validate();
    if (_validationError != '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_validationError),
        backgroundColor: Colors.red,
      ));
      _validationError = '';
      return false;
    }
    return true;
  }

  // Submit form and authenticates online, diplays dialog if error
  Future<void> _submitForm(BuildContext context) async {
    if (!_validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    // Try to authenticate and displays an error dialog in case of failure
    try {
      if (_authMode == AuthMode.Signup) {
        await Provider.of<Auth>(context, listen: false)
            .register(_credentials['email']!, _credentials['password']!)
            .then((value) => Navigator.of(context)
                .popAndPushNamed(AlbumsListScreen.routeName));
      } else {
        await Provider.of<Auth>(context, listen: false)
            .login(_credentials['email']!, _credentials['password']!)
            .then((value) => Navigator.of(context)
                .popAndPushNamed(AlbumsListScreen.routeName));
      }
    } on HttpException catch (err) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialogFactory.oneButtonDialog(
              ctx, 'Error', err.message.toString(), 'OK'));
    } catch (err, stack) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingWidget()
        : Card(
            elevation: 8,
            child: Form(
                key: _formKey,
                child: Container(
                  height: _heightAnimation.value.height,
                  padding: EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ServerInfo(),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Email address'),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _saveField('email', value),
                          validator: (value) {
                            if (value!.isEmpty) {
                              _validationError = 'Email required';
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          onSaved: (value) => _saveField('password', value),
                          validator: (value) {
                            if (value!.isEmpty) {
                              _validationError = 'Password required';
                              return null;
                            }
                          },
                        ),
                        if (_authMode == AuthMode.Signup)
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Confirm the password"),
                            obscureText: true,
                            // validator: (value) {
                            //   if (value != _credentials['password'])
                            //     _validationError = 'Passwords must be the same';
                            // },
                          ),
                        TextButton(
                          child: Text(
                              _authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'),
                          onPressed: () => _toggleAuthMode(),
                        ),
                        TextButton(
                          child: Text('OK'),
                          onPressed: () => _submitForm(context),
                        )
                      ],
                    ),
                  ),
                )));
  }
}
