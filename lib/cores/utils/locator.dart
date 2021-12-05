import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/controller/locatiom_controller.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:food_dash_app/features/payment/repo/payment_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton<AuthenticationRepo>(() => AuthenticationRepo());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<MerchantRepo>(() => MerchantRepo());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarService());
  locator.registerLazySingleton<LocaldatabaseRepo>(() => LocaldatabaseRepo());
  locator.registerLazySingleton<PaymentRepo>(() => PaymentRepo());
  Get.put<LocationController>(LocationController());
}
