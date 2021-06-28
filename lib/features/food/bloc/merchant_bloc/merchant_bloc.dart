import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:get_it/get_it.dart';

part 'merchant_event.dart';
part 'merchant_state.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  MerchantBloc() : super(MerchantInitial());

  MerchantRepo merchantRepo = GetIt.instance<MerchantRepo>();
  MerchantModel? lastmerchant;
  FoodProductModel? lastFoodProduct;
  bool merchantBusy = false;
  bool foodBusy = false;
  bool hasMoreMerchant = true;
  bool hasMoreFoodProduct = true;

  @override
  Stream<MerchantState> mapEventToState(
    MerchantEvent event,
  ) async* {
    if (event is GetMerchantsEvents) {
      merchantBusy = true;
      try {
        yield GetMerchantLoadingState();
        final List<MerchantModel> merchants =
            await merchantRepo.getMerchant(lastMerchant: lastmerchant);
        lastmerchant = merchants.last;
        hasMoreMerchant = merchants.length == merchantRepo.limit;
        yield GetMerchantLoadedState(merchants);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetMerchantErrorState(e.toString());
      }
      merchantBusy = false;
    } else if (event is GetFoodProductsEvents) {
      foodBusy = true;
      try {
        yield GetFoodProductsLoadingState();
        final List<FoodProductModel> foodProducts = await merchantRepo
            .getFoodProduct(event.merchantId, lastFoodProduct: lastFoodProduct);
        lastFoodProduct = foodProducts.last;
        hasMoreFoodProduct = foodProducts.length == merchantRepo.limit;
        yield GetFoodProductsLoadedState(foodProducts);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetFoodProductsErrorState(e.toString());
      }
      foodBusy = false;
    }
  }
}
