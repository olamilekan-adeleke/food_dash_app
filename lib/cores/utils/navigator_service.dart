import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomNavigationService {
  static final NavigationService _navigationService =
      locator<NavigationService>();

  Future<dynamic>? navigateTo(String routeName, {dynamic argument}) {
    debugPrint(routeName);

    return _navigationService.navigateTo(routeName, arguments: argument);
  }

  Future<dynamic>? navigateRecplace(String routeName, {dynamic argument}) {
    debugPrint(routeName);
    return _navigationService.replaceWith(routeName, arguments: argument);
  }

  Future<bool> goBack() async {
    return await _navigationService.back();
  }

  Future<void> show() async {
    Navigator.pop(Get.overlayContext!);
    Get.defaultDialog(
      title: 'Loading Please Wait...',
      onWillPop: () async => false,
      barrierDismissible: false,
      content: Container(
        child: CustomLoadingIndicatorWidget(),
      ),
    );
  }

  void popShow() {
    Navigator.pop(Get.overlayContext!);
  }
}
