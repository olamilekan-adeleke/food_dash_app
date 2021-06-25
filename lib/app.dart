import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/utils/bloc_list.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:get_it/get_it.dart';

import 'cores/utils/route_name.dart';
import 'cores/utils/router.dart';

class MyApp extends StatelessWidget {
  final NavigationService navigationService =
      GetIt.instance<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocList(context),
      child: MaterialApp(
        title: 'Food Dash',
        theme: ThemeData(primarySwatch: Colors.blue),
        navigatorKey: navigationService.navigatorKey,
        onGenerateRoute: generateRoute,
        initialRoute: RouteName.inital,
      ),
    );
  }
}
