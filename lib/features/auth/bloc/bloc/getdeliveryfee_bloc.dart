import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';

part 'getdeliveryfee_event.dart';
part 'getdeliveryfee_state.dart';

class GetdeliveryfeeBloc
    extends Bloc<GetdeliveryfeeEvent, GetdeliveryfeeState> {
  GetdeliveryfeeBloc() : super(GetdeliveryfeeInitial());

  @override
  Stream<GetdeliveryfeeState> mapEventToState(
    GetdeliveryfeeEvent event,
  ) async* {
    if (event is GetFeeEvent) {
      try {
        yield GetdeliveryfeeLoading();
        final int fee = await MerchantRepo().getDeliveryFee();
        yield GetdeliveryfeeLoaded(fee);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetdeliveryfeeError(e.toString());
      }
    }
  }
}
