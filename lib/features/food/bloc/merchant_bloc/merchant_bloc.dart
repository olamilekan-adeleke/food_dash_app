import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
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
    } else if (event is AddFoodProductToFavouriteEvents) {
      try {
        yield AddFoodProductToFavouriteLoadingState(event.foodProduct.id);
        await merchantRepo.addToFavourite(event.foodProduct);
        yield const AddFoodProductToFavouriteLoadedState();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AddFoodProductToFavouriteErrorState(e.toString());
      }
    } else if (event is RemoveFoodProductToFavouriteEvents) {
      try {
        yield RemoveFoodProductToFavouriteLoadingState(event.foodProductId);
        await merchantRepo.removeFromFavourite(event.foodProductId);
        yield const RemoveFoodProductToFavouriteLoadedState();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield RemoveFoodProductToFavouriteErrorState(e.toString());
      }
    } else if (event is AddFoodProductToCartEvents) {
      try {
        yield AddFoodProductToCartLoadingState(event.foodProduct.id);
        await merchantRepo.addToCart(event.foodProduct);
        yield AddFoodProductToCartLoadedState();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AddFoodProductToCartErrorState(e.toString());
      }
    } else if (event is RemoveFoodProductToCartEvents) {
      try {
        yield RemoveFoodProductToCartLoadingState(event.foodProductId);
        await merchantRepo.removeFromCart(event.index);
        yield const RemoveFoodProductToCartLoadedState();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield RemoveFoodProductToCartErrorState(e.toString());
      }
    } else if (event is GetCartItemEvents) {
      try {
        yield GetCartItemLoadingState();
        final List<CartModel> cartList = await merchantRepo.getCart();
        yield GetCartItemLoadedState(cartList);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetCartItemErrorState(e.toString());
      }
    } else if (event is GetFavouritesItemEvents) {
      try {
        yield GetFavouriteLoadingState();
        final List<FoodProductModel> foodList =
            await merchantRepo.getFavourites();
        yield GetFavouriteLoadedState(foodList);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetFavouriteErrorState(e.toString());
      }
    }
  }
}
