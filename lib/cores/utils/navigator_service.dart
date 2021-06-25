import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic argument}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: argument);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
