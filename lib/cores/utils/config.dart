import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:food_dash_app/features/payment/repo/payment_repo.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get_storage/get_storage.dart' as storage;
import 'package:get/get.dart';

import 'firebase_messaging_utils.dart';

class Config {
  static const String userDataBox = 'user';
  static const String cartDataBox = 'cart';
  static final SnackbarService _snackbarService = locator<SnackbarService>();
  static final LocaldatabaseRepo _localdatabaseRepo =
      locator<LocaldatabaseRepo>();
  static final PaystackPlugin paystackPlugin = PaystackPlugin();

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
    /// init local database using get storage.
    ///
    await storage.GetStorage.init('box');
    await _localdatabaseRepo.setListener();
    await _localdatabaseRepo.setListenerMarket();
    await _localdatabaseRepo.setListenerForUserData();
    await NotificationMethods.initNotification();
    await paystackPlugin.initialize(publicKey: publicKey);
  }
}
