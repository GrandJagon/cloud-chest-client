import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/config_helper.dart';
import 'widgets/cloud_chest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config().init();
  await dotenv.load(fileName: 'lib/.env');
  runApp(CloudChest());
}
