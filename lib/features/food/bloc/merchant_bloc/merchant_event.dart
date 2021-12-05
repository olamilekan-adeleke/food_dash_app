part of 'merchant_bloc.dart';

abstract class MerchantEvent extends Equatable {
  const MerchantEvent();

  @override
  List<Object> get props => <Object>[];
}

/// get merchants list event
class GetMerchantsEvents extends MerchantEvent {
  const GetMerchantsEvents(this.fresh, {this.isHome});
  final bool fresh;
  final bool? isHome;
}

/// get popular food
class GetPopularFoodEvents extends MerchantEvent {}

/// get food product list  event
class GetFoodProductsEvents extends MerchantEvent {
  const GetFoodProductsEvents(this.merchantId, this.fresh);

  final String merchantId;
  final bool fresh;
}

/// add food item to favourite
class AddFoodProductToFavouriteEvents extends MerchantEvent {
  const AddFoodProductToFavouriteEvents(this.foodProduct);

  final FoodProductModel foodProduct;
}

// /// add market item to favourite
// class AddFoodProductToFavouriteEvents extends MerchantEvent {
//   const AddFoodProductToFavouriteEvents(this.foodProduct);

//   final FoodProductModel foodProduct;
// }

/// remove food item to favourite
class RemoveFoodProductToFavouriteEvents extends MerchantEvent {
  const RemoveFoodProductToFavouriteEvents(this.foodProductId);

  final String foodProductId;
}

/// add food item to cart
class AddFoodProductToCartEvents extends MerchantEvent {
  const AddFoodProductToCartEvents(this.foodProduct);

  final CartModel foodProduct;
}

/// add food item to cart
class AddMarketItemProductToCartEvents extends MerchantEvent {
  const AddMarketItemProductToCartEvents(this.marketItem);

  final CartModel marketItem;
}

/// remove food item to cart
class RemoveFoodProductToCartEvents extends MerchantEvent {
  const RemoveFoodProductToCartEvents(this.foodProductId, this.index);

  final String foodProductId;
  final int index;
}

/// remove food item to cart
class GetCartItemEvents extends MerchantEvent {}

/// remove food item to cart
class GetFavouritesItemEvents extends MerchantEvent {}

// make payment for food order event
class MakePaymentEvent extends MerchantEvent {
  const MakePaymentEvent(
    this.devlieryFee,
    this.isWalletTop, {
    this.cardPayment = false,
  });
  final bool cardPayment;
  final int devlieryFee;
  final bool isWalletTop;
}

// rate rider
class RateRiderEvent extends MerchantEvent {
  const RateRiderEvent(this.orderId, this.riderId, this.rating);

  final String orderId;
  final String riderId;
  final double rating;
}

// serach
class SearchEvent extends MerchantEvent {
  const SearchEvent(this.query);
  final String query;
}

class SearchMarketEvent extends MerchantEvent {
  const SearchMarketEvent(this.query);
  final String query;
}

class GetMarketItemsEvent extends MerchantEvent {
  const GetMarketItemsEvent(this.fresh);
  final bool fresh;
}
