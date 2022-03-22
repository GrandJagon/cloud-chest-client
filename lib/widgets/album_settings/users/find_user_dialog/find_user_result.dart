import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/user_selection_view_model.dart';
import 'package:cloud_chest/widgets/album_settings/users/find_user_dialog/single_user_result.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cloud_chest/widgets/misc/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindUserResult extends StatefulWidget {
  @override
  State<FindUserResult> createState() => _FindUserResultState();
}

class _FindUserResultState extends State<FindUserResult> {
  late UserSelectionViewModel vm;

  @override
  Widget build(BuildContext context) {
    vm = context.watch<UserSelectionViewModel>();

    if (vm.response.status == ResponseStatus.LOADING_FULL)
      return LoadingWidget();
    else if (vm.response.status == ResponseStatus.NO_RESULT)
      return _noResult(vm.response.message!);
    else if (vm.response.status == ResponseStatus.DONE)
      return _buildResult(context);
    else
      return NetworkErrorWidget(
        message: 'An error occured while looking for user',
        changeConfig: false,
      );
  }

  Widget _buildResult(BuildContext context) {
    if (vm.searchUserResult!.isNotEmpty)
      return _resultTable();
    else
      return Container();
  }

  Widget _resultTable() {
    return Column(
      children: [
        Text(
          'Select a user to add',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white54),
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.all(12),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: vm.searchUserResult!.length,
            itemBuilder: (ctx, i) => SingleUserResult(vm.searchUserResult![i]),
          ),
        ),
      ],
    );
  }

  Widget _noResult(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
      ),
    );
  }
}
