import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get/get.dart';

class Config {
  static const String userDataBox = 'user';
  static const String cartDataBox = 'cart';
  static final SnackbarService _snackbarService =
      GetIt.instance<SnackbarService>();

  static void setUpSnackBarConfig() {
    _snackbarService.registerCustomSnackbarConfig(
      variant: SnackBarType.success,
      config: SnackbarConfig(
        backgroundColor: Colors.green,
        borderRadius: 5.0,
        snackPosition: SnackPosition.TOP,
      ),
    );

    _snackbarService.registerCustomSnackbarConfig(
      variant: SnackBarType.error,
      config: SnackbarConfig(
        backgroundColor: Colors.red,
        borderRadius: 5.0,
        snackPosition: SnackPosition.TOP,
      ),
    );

    _snackbarService.registerCustomSnackbarConfig(
      variant: SnackBarType.warning,
      config: SnackbarConfig(
        backgroundColor: Colors.grey,
        borderRadius: 5.0,
        snackPosition: SnackPosition.TOP,
      ),
    );
  }

  static Future<void> setUpHiveLocalDB() async {
    /// init local database using hive.
    ///
    await Hive.initFlutter();
    await Hive.openBox<Map<String, dynamic>>(userDataBox);
    await Hive.openBox<List<Map<String, dynamic>>>(cartDataBox);
  }
}
