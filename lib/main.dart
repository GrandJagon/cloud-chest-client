import 'dart:io';
import 'package:cloud_chest/helpers/persistance/db_helper.dart';
import 'package:cloud_chest/utils/http_overrides.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/config_helper.dart';
import 'widgets/start/cloud_chest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new CustomHttpOverrides();
  await Config().init();
  await dotenv.load(fileName: 'lib/.env');

  runApp(CloudChest());
}
