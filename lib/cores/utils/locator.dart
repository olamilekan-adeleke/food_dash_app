import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton<AuthenticationRepo>(() => AuthenticationRepo());
  locator.registerLazySingleton<CustomNavigationService>(
      () => CustomNavigationService());
  locator.registerLazySingleton<MerchantRepo>(() => MerchantRepo());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarService());
}
