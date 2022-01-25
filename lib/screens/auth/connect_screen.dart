import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/config_helper.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';

// Class responsible for connecting to the server when app first use
class ConnectScreen extends StatefulWidget {
  static final routeName = '/connectScreen';

  @override
  State<StatefulWidget> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _configValues = {'host': '', 'port': ''};
  var _isLoading = false;

  void _saveField(String key, String? value) {
    if (value == null) value = '';
    _configValues[key] = value;
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _formKey.currentState!.save();
      Config().update('host', _configValues['host']!);
      Config().update('port', _configValues['port']!);
      await Config().savePreferences();

      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? LoadingWidget()
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                            'Welcome to cloud chest, you seem not to have any server configuration in memory. Please type in your server host and port number to start.'),
                      ),
                    ),
                    TextFormField(
                      initialValue:
                          Config().isSetup ? Config().get('host') : null,
                      decoration: const InputDecoration(
                          labelText: 'Hostname/IP Address'),
                      onSaved: (value) => _saveField('host', value),
                      validator: (value) {
                        if (value == null) return 'Host must not be null';
                      },
                    ),
                    TextFormField(
                        initialValue:
                            Config().isSetup ? Config().get('port') : null,
                        decoration:
                            const InputDecoration(labelText: 'Port number'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _saveField('port', value),
                        validator: (value) {
                          if (value == null)
                            return 'Port number must not be null';
                        }),
                    TextButton(
                      child: Text('Save configuration'),
                      onPressed: () => _submitForm(),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
