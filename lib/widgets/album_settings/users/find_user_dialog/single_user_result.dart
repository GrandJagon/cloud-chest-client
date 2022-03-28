import 'package:cloud_chest/models/user.dart';
import 'package:cloud_chest/view_model/user_search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleUserResult extends StatefulWidget {
  final User user;

  SingleUserResult(this.user);

  @override
  State<SingleUserResult> createState() => _SingleUserResultState();
}

class _SingleUserResultState extends State<SingleUserResult> {
  bool _isSelected = false;
  late UserSearchViewModel vm;

  // Displays card color and sends user to parent
  void _onTap(BuildContext context) {
    setState(() {
      _isSelected = !_isSelected;
    });
    vm.user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    vm = context.read<UserSearchViewModel>();
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
                width: 3, color: _isSelected ? Colors.green : Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.user.username != null
                      ? Text(
                          widget.user.username!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : Container(),
                  Text(
                    widget.user.email,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              _isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 40,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
