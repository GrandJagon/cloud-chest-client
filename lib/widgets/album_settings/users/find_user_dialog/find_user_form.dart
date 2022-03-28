import 'package:cloud_chest/view_model/album_settings_view_model.dart';
import 'package:cloud_chest/view_model/user_search_view_model.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Text(
            'Find user by username or email',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white54),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                          controller: _controller,
                        ),
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
