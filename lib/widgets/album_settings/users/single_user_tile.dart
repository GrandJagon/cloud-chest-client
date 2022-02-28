import 'package:cloud_chest/models/factories/right_icon_factory.dart';
import 'package:cloud_chest/models/user.dart';
import 'package:cloud_chest/widgets/album_settings/users/right_icon.dart';
import 'package:flutter/material.dart';

class SingleUserTile extends StatelessWidget {
  final User user;

  SingleUserTile(this.user);

  // Opens the detail dialog for this particular user right
  // Will also to change rights or remove users
  void _onTap() {
    print('User rights detail opened');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  user.username ?? user.email,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ..._createRightList(user)
            ],
          ),
        ),
      ),
    );
  }
}

List<RightIcon> _createRightList(User user) {
  List<RightIcon> icons = [];

  user.rights.forEach((right) {
    icons.add(RightIconFactory.createIcon(right));
  });

  print(icons);

  return icons;
}
