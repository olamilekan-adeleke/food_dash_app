import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setUp() {
  locator.registerLazySingleton<AuthenticationRepo>(() => AuthenticationRepo());
}
