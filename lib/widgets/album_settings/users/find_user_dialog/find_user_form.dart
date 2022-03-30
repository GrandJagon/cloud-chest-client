import 'package:cloud_chest/view_model/album_settings/user_search_view_model.dart';
import 'package:cloud_chest/widgets/misc/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindUserForm extends StatefulWidget {
  @override
  State<FindUserForm> createState() => _FindUserFormState();
}

class _FindUserFormState extends State<FindUserForm> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _search(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      await Provider.of<UserSearchViewModel>(context, listen: false)
          .findUser(_controller.text);
    } catch (e, stack) {
      print(stack);
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find user by username or email',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: RoundedTextField(controller: _controller)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                size: 25,
                color: Colors.white,
              ),
              onPressed: () => _search(context),
            ),
          ],
        ),
      ],
    );
  }
}
