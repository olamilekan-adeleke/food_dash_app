import 'package:flutter/material.dart';

import 'package:food_dash_app/cores/components/error_navigation_wiget.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/features/auth/UI/pages/forgot_password_page.dart';
import 'package:food_dash_app/features/auth/UI/pages/login.dart';
import 'package:food_dash_app/features/auth/UI/pages/sig_up_page.dart';
import 'package:food_dash_app/features/auth/UI/pages/wrapper_page.dart';
import 'package:food_dash_app/features/food/UI/pages/cart_page.dart';
import 'package:food_dash_app/features/food/UI/pages/home_page.dart';
import 'package:food_dash_app/features/food/UI/pages/payment_page.dart';
import 'package:food_dash_app/features/food/UI/pages/selected_food_page.dart';
import 'package:food_dash_app/features/food/UI/pages/selected_merchant_page.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.inital:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const WrapperPage());

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

    case RouteName.selectedMerchantPage:
      if (settings.arguments is MerchantModel) {
        // ignore: cast_nullable_to_non_nullable
        final MerchantModel merchant = settings.arguments as MerchantModel;

        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) => SelectedMerchantPage(merchant));
      }
      break;

    case RouteName.selectedFoodPage:
      if (settings.arguments is FoodProductModel) {
        final FoodProductModel? foodProduct =
            settings.arguments as FoodProductModel?;

        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) =>
                SelectedFoodPage(foodProduct: foodProduct));
      }
      break;

    case RouteName.cartPage:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const CartPage());

    case RouteName.paymentPage:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const PaymentPage());

    default:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ErrornavigationWidget());
  }
}
