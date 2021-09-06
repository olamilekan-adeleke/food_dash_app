import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:food_dash_app/features/food/UI/widgets/market_items_widget.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';
import 'package:food_dash_app/features/food/model/market_item_model.dart';
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
  FoodProductModel? lastMerchantFoodProduct;
  FoodProductModel? search;
  MarketItemModel? lastMarketSearch;
  FoodProductModel? lastFavFoodProduct;
  MarketItemModel? lastMarketItem;

  bool merchantBusy = false;
  bool foodBusy = false;
  bool merchantFoodBusy = false;
  bool foodFavBusy = false;
  bool searchBusy = false;
  bool searchMarketBusy = false;
  bool marketBusy = false;

  bool hasMoreMerchant = true;
  bool hasMoreFavFood = true;
  bool hasMoreFoodProduct = true;
  bool hasMoreMerchantFoodProduct = true;
  bool hasMoreSearch = true;
  bool hasMoreMarketSearch = true;
  bool hasMoreMarket = true;

  @override
  Stream<MerchantState> mapEventToState(
    MerchantEvent event,
  ) async* {
    if (event is GetMerchantsEvents) {
      merchantBusy = true;
      try {
        yield GetMerchantLoadingState();
        final List<MerchantModel> merchants = await merchantRepo.getMerchant(
          lastMerchant: event.fresh ? null : lastmerchant,
        );
        if (merchants.isNotEmpty) lastmerchant = merchants.last;
        hasMoreMerchant = merchants.length == merchantRepo.limit;
        yield GetMerchantLoadedState(merchants);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetMerchantErrorState(e.toString());
      }
      merchantBusy = false;
    } else if (event is GetFoodProductsEvents) {
      merchantFoodBusy = true;
      try {
        yield GetFoodProductsLoadingState();
        final List<FoodProductModel> foodProducts =
            await merchantRepo.getFoodProduct(
          event.merchantId,
          lastFoodProduct: event.fresh ? null : lastMerchantFoodProduct,
        );

        if (foodProducts.isNotEmpty)
          lastMerchantFoodProduct = foodProducts.last;

        hasMoreMerchantFoodProduct = foodProducts.length == merchantRepo.limit;
        yield GetFoodProductsLoadedState(foodProducts);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetFoodProductsErrorState(e.toString());
      }
      merchantFoodBusy = false;
    } else if (event is GetMarketItemsEvent) {
      marketBusy = true;
      try {
        yield GetMarketItemLoadingState();
        final List<MarketItemModel> marketItems = await merchantRepo
            .getMarketItem(event.fresh ? null : lastMarketItem);
        if (marketItems.isNotEmpty) lastMarketItem = marketItems.last;
        hasMoreMerchantFoodProduct = marketItems.length == merchantRepo.limit;
        yield GetMarketItemLoadedState(marketItems);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetMarketItemErrorState(e.toString());
      }
      marketBusy = false;
    } else if (event is GetPopularFoodEvents) {
      foodFavBusy = true;
      try {
        yield GetPopularFoodLoadingState();
        final List<FoodProductModel> foodProducts = await merchantRepo
            .getTopFoodProduct(lastFoodProduct: lastFoodProduct);
        if (foodProducts.isNotEmpty) lastFavFoodProduct = foodProducts.last;
        hasMoreFavFood = foodProducts.length == merchantRepo.limit;
        yield GetPopularFoodLoadedState(foodProducts);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield GetPopularFoodErrorState(e.toString());
      }
      foodFavBusy = false;
    } else if (event is SearchEvent) {
      searchBusy = true;
      try {
        yield SearchLoadingState();
        final List<FoodProductModel> foodProducts =
            await merchantRepo.search(event.query, foodProduct: search);
        if (foodProducts.isNotEmpty) search = foodProducts.last;
        hasMoreSearch = foodProducts.length == merchantRepo.limit;
        yield SearchLoadedState(foodProducts);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield SearchErrorState(e.toString());
      }
      searchBusy = false;
    } else if (event is SearchMarketEvent) {
      searchMarketBusy = true;
      try {
        yield SearchMarketLoadingState();
        final List<MarketItemModel> items = await merchantRepo
            .searchMarket(event.query, marketItem: lastMarketSearch);

        if (items.isNotEmpty) lastMarketSearch = items.last;
        hasMoreMarketSearch = items.length == merchantRepo.limit;
        yield SearchMarketLoadedState(items);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield SearchMarketErrorState(e.toString());
      }
      searchMarketBusy = false;
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
    } else if (event is AddMarketItemProductToCartEvents) {
      try {
        yield AddMarketItemToCartLoadingState(event.marketItem.id);
        await merchantRepo.addToCartMarket(event.marketItem);
        yield AddMarketItemToCartLoadedState();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AddMarketItemToCartErrorState(e.toString());
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
    } else if (event is MakePaymentEvent) {
      try {
        yield MakePaymentLoadingState();
        final String id =
            await merchantRepo.makePayment(event.password, event.devlieryFee);
        yield MakePaymentLoadedState(id);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield MakePaymentErrorState(e.toString());
      }
    } else if (event is RateRiderEvent) {
      try {
        yield RateRiderLoadingState();
        await merchantRepo.rateRider(
          event.orderId,
          event.riderId,
          event.rating,
        );
        yield RateRiderLoadedState();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield RateRiderErrorState(e.toString());
      }
    }
  }
}
