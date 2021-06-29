import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/utils/bloc_list.dart';
import 'package:stacked_services/stacked_services.dart';
import 'cores/utils/route_name.dart';
import 'cores/utils/router.dart';

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocList(context),
      child: MaterialApp(
        title: 'Food Dash',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: generateRoute,
        initialRoute: RouteName.inital,
      ),
    );
  }
}
