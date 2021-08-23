import 'package:flutter/material.dart';
import 'package:food_dash_app/features/auth/UI/pages/login.dart';
import 'package:food_dash_app/features/auth/model/login_user_model.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/UI/pages/home_tab_pages.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({Key? key}) : super(key: key);

  static final AuthenticationRepo authenticationRepo =
      GetIt.instance<AuthenticationRepo>();
  static final LocaldatabaseRepo localdatabaseRepo =
      GetIt.instance<LocaldatabaseRepo>();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LoginUserModel?>.value(
      initialData: null,
      value: authenticationRepo.userAuthState,
      builder: (BuildContext context, Widget? child) {
        return const AuthStateWidget();
      },
    );
  }
}

class AuthStateWidget extends StatefulWidget {
  const AuthStateWidget();

  @override
  _AuthStateWidgetState createState() => _AuthStateWidgetState();
}

class _AuthStateWidgetState extends State<AuthStateWidget> {
  @override
  Widget build(BuildContext context) {
    Widget widget;
    final LoginUserModel? loginUserModel =
        Provider.of<LoginUserModel?>(context, listen: true);

    final ValueNotifier<UserDetailsModel?> userDetail =
        LocaldatabaseRepo.userDetail;

    userDetail.addListener(() {
      setState(() {});
    });

    if (loginUserModel == null || userDetail.value == null) {
      widget = const LoginPage();
    } else {
      widget = const HomeTabScreen();
    }

    return Scaffold(body: widget);
  }
}
