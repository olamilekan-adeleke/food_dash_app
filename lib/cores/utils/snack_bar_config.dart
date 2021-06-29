import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

class Config {
  static final SnackbarService _snackbarService =
      GetIt.instance<SnackbarService>();

  static void setUpSnackBarConfig() {
    _snackbarService.registerCustomSnackbarConfig(
      variant: SnackBarType.success,
      config: SnackbarConfig(
        backgroundColor: Colors.green,
        borderRadius: 5.0,
        forwardAnimationCurve: Curves.bounceInOut,
      ),
    );

    _snackbarService.registerCustomSnackbarConfig(
      variant: SnackBarType.error,
      config: SnackbarConfig(
        backgroundColor: Colors.red,
        borderRadius: 5.0,
        forwardAnimationCurve: Curves.bounceInOut,
      ),
    );

    _snackbarService.registerCustomSnackbarConfig(
      variant: SnackBarType.warning,
      config: SnackbarConfig(
        backgroundColor: Colors.grey,
        borderRadius: 5.0,
        forwardAnimationCurve: Curves.bounceInOut,
      ),
    );
  }
}
