import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';

List<BlocProvider<dynamic>> blocList(BuildContext context) {
  return <BlocProvider<dynamic>>[
    BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
    BlocProvider<MerchantBloc>(
        create: (BuildContext context) => MerchantBloc()),
  ];
}
