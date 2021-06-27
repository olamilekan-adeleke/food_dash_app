import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName, {dynamic argument}) {
    debugPrint(routeName);
    return navigatorKey.currentState?.pushNamed(routeName, arguments: argument);
  }

  Future<dynamic>? navigateRecplace(String routeName, {dynamic argument}) {
    debugPrint(routeName);
    return navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: argument);
  }

  Future<void>? navigateToUsingWidget(Widget widget) {
    debugPrint('ll');
    if (navigatorKey.currentState != null) {
      debugPrint('ll3');
      return navigatorKey.currentState?.push(
          MaterialPageRoute<Widget>(builder: (BuildContext context) => widget));
    }

    // return null;
  }

  Future<dynamic>? navigateRepalceUsingWidget(Widget widget) {
    return navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute<Widget>(builder: (BuildContext context) => widget));
  }

  Future<dynamic>? navigateToDefault(BuildContext context, Widget widget) {
    return Navigator.of(context).push(
        MaterialPageRoute<Widget>(builder: (BuildContext context) => widget));
  }

  Future<dynamic>? navigateReplaceDefault(BuildContext context, Widget widget) {
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute<Widget>(builder: (BuildContext context) => widget));
  }

  void goBack() {
    return navigatorKey.currentState?.pop();
  }
}
