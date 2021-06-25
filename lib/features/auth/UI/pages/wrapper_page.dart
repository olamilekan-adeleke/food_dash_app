import 'package:flutter/material.dart';
import 'package:food_dash_app/features/auth/UI/pages/login.dart';
import 'package:food_dash_app/features/auth/model/login_user_model.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/UI/pages/home_page.dart';
import 'package:get_it/get_it.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({Key? key}) : super(key: key);

  static final AuthenticationRepo authenticationRepo =
      GetIt.instance<AuthenticationRepo>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<LoginUserModel?>(
        stream: authenticationRepo.userAuthState,
        builder:
            (BuildContext context, AsyncSnapshot<LoginUserModel?> snapshot) {
          final LoginUserModel? loginUserModel = snapshot.data;

          if (loginUserModel == null) {
            return const LoginPage();
          } else {
            return const HomePage();
          }
        },
      ),
    );
  }
}
