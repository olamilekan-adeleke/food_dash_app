import 'package:flutter/material.dart';

import 'package:food_dash_app/cores/components/error_navigation_wiget.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/features/auth/UI/pages/forgot_password_page.dart';
import 'package:food_dash_app/features/auth/UI/pages/login.dart';
import 'package:food_dash_app/features/auth/UI/pages/sig_up_page.dart';
import 'package:food_dash_app/features/food/UI/pages/home_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.home:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const HomePage());

    case RouteName.login:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const LoginPage());

    case RouteName.signup:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const SignUpPage());

    case RouteName.forgotPassword:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ForgotPasswordPage());

    default:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ErrornavigationWidget());
  }
}
