import 'dart:ui';
import 'package:cloud_chest/widgets/album_settings/users/find_user_dialog/find_user_form.dart';
import 'package:cloud_chest/widgets/album_settings/users/find_user_dialog/find_user_result.dart';
import 'package:cloud_chest/widgets/album_settings/users/find_user_dialog/validate_button.dart';
import 'package:flutter/material.dart';

class FindUserDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(12),
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FindUserForm(),
                    SizedBox(
                      height: 80,
                    ),
                    FindUserResult()
                  ],
                ),
              ),
            ),
          ),
          ValidateButton()
        ],
      ),
    );
  }
}
