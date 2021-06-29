part of 'merchant_bloc.dart';

abstract class MerchantEvent extends Equatable {
  const MerchantEvent();

  @override
  List<Object> get props => <Object>[];
}

/// get merchants list event
class GetMerchantsEvents extends MerchantEvent {}

/// get food product list  event
class GetFoodProductsEvents extends MerchantEvent {
  const GetFoodProductsEvents(this.merchantId);

  final String merchantId;
}


/// add food item to favourite
class AddFoodProductToFavouriteEvents extends MerchantEvent {
  const AddFoodProductToFavouriteEvents(this.foodProduct);

  final FoodProductModel foodProduct;
}

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

/// remove food item to cart
class RemoveFoodProductToCartEvents extends MerchantEvent {
  const RemoveFoodProductToCartEvents(this.foodProductId);

  final String foodProductId;
}
