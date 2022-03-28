import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/account_settings_view_model.dart';
import 'package:cloud_chest/widgets/account/account_settings_form.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cloud_chest/widgets/misc/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static String routeName = '/account';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AccountSettingsViewModel vm;

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<AccountSettingsViewModel>(context, listen: false)
            .fetchUserDetails());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<AccountSettingsViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Account settings'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (vm.response.status == ResponseStatus.LOADING_FULL ||
        vm.response.status == ResponseStatus.LOADING_PARTIAL)
      return LoadingWidget();
    if (vm.response.status == ResponseStatus.ERROR)
      return NetworkErrorWidget(
        retryCallback: vm.fetchUserDetails,
      );
    else
      return AccountSettingsForm(
          vm.userDetails['email']!, vm.userDetails['username']!);
  }
}
