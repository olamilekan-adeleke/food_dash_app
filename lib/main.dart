import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/utils/config.dart';

import 'app.dart';
import 'cores/utils/locator.dart';
import 'features/food/repo/request_compltion_listener.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  Config.setUpSnackBarConfig();
  await Firebase.initializeApp();
  await Config.setUpHiveLocalDB();
  // RequestCompletionListener();
  // FakeMarketPlace().init();
  runApp(MyApp());
}
