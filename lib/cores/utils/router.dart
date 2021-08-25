import 'package:flutter/material.dart';

import 'package:food_dash_app/cores/components/error_navigation_wiget.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/features/auth/UI/pages/forgot_password_page.dart';
import 'package:food_dash_app/features/auth/UI/pages/login.dart';
import 'package:food_dash_app/features/auth/UI/pages/sig_up_page.dart';
import 'package:food_dash_app/features/auth/UI/pages/wrapper_page.dart';
import 'package:food_dash_app/features/food/UI/pages/cart_page.dart';
import 'package:food_dash_app/features/food/UI/pages/change_password_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/edit_address_page.dart';
import 'package:food_dash_app/features/food/UI/pages/edit_profile_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/home_page.dart';
import 'package:food_dash_app/features/food/UI/pages/home_tab_pages.dart';
import 'package:food_dash_app/features/food/UI/pages/market_serach_page.dart';
import 'package:food_dash_app/features/food/UI/pages/notification_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/order_history_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/order_status_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/payment_history_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/profile_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/restaurant_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/reveiw_screem.dart';
import 'package:food_dash_app/features/food/UI/pages/search_page.dart';
import 'package:food_dash_app/features/food/UI/pages/selected_market_item_page.dart';
import 'package:food_dash_app/features/food/model/market_item_model.dart';
import 'package:food_dash_app/features/payment/Ui/pages/payment_page.dart';
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

    case RouteName.hometab:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const HomeTabScreen());

    case RouteName.restaurantPage:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const RestaurantScreen());

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

      case RouteName.selectedMarketItemPage:
      if (settings.arguments is MarketItemModel) {
        final MarketItemModel? marketItem =
            settings.arguments as MarketItemModel?;

        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) =>
                SelectedMarketItmePage(marketItem: marketItem!));
      }
      break;

    case RouteName.cartPage:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const CartPage());

          case RouteName.notificationPage:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const NotificationScreen());

    case RouteName.paymentPage:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const PaymentPage());

    case RouteName.editAddress:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const EditAddressScreen());

    case RouteName.profileScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ProfileScreen());

    case RouteName.editProfileScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const EditprofileScreen());

    case RouteName.oderHistoryScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const OrderHistoryScreen());

    case RouteName.changePasswordScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ChangePasswordScreen());

    case RouteName.foodSearchScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const FoodSearchScreen());

          case RouteName.marketSearchScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const MarketSearchScreen());


    case RouteName.paymentHistoryScreen:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const PaymentHistoryScreen());

    case RouteName.orderStatus:
      if (settings.arguments is String) {
        // ignore: cast_nullable_to_non_nullable
        final String id = settings.arguments as String;

        return MaterialPageRoute<Widget>(
            builder: (BuildContext context) => OrderStatusScreen(id));
      }
      break;

    case RouteName.reviewScreen:
      if (settings.arguments is Map<String, dynamic>) {
        // ignore: cast_nullable_to_non_nullable
        final Map<String, dynamic>? data =
            settings.arguments as Map<String, dynamic>?;
        final String orderId = data!['orderId'] as String;
        final String riderId = data['riderId'] as String;

        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => ReviewScreen(
            orderId: orderId,
            riderId: riderId,
          ),
        );
      }
      break;

    default:
      return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ErrornavigationWidget());
  }
}
