import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/utils/config.dart';

import 'app.dart';
import 'cores/utils/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  Config.setUpSnackBarConfig();
  await Config.setUpHiveLocalDB();
  await Firebase.initializeApp();
  runApp(MyApp());
}
