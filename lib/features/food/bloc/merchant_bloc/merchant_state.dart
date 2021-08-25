part of 'merchant_bloc.dart';

abstract class MerchantState extends Equatable {
  const MerchantState();

  @override
  List<Object> get props => <Object>[];
}

class MerchantInitial extends MerchantState {}

/// get merchants state
class GetMerchantInitialState extends MerchantState {}

class GetMerchantLoadingState extends MerchantState {}

class GetMerchantLoadedState extends MerchantState {
  const GetMerchantLoadedState(this.merchants);

  final List<MerchantModel> merchants;
}

class GetMerchantErrorState extends MerchantState {
  const GetMerchantErrorState(this.message);

  final String message;
}

/// get merchants state
class GetPopularFoodInitialState extends MerchantState {}

class GetPopularFoodLoadingState extends MerchantState {}

class GetPopularFoodLoadedState extends MerchantState {
  const GetPopularFoodLoadedState(this.foodList);

  final List<FoodProductModel> foodList;
}

class GetPopularFoodErrorState extends MerchantState {
  const GetPopularFoodErrorState(this.message);

  final String message;
}

/// get food product state
class GetFoodProductsInitialState extends MerchantState {}

class GetFoodProductsLoadingState extends MerchantState {}

class GetFoodProductsLoadedState extends MerchantState {
  const GetFoodProductsLoadedState(this.merchants);

  final List<FoodProductModel> merchants;
}

class GetFoodProductsErrorState extends MerchantState {
  const GetFoodProductsErrorState(this.message);

  final String message;
}

/// add food product to favourite state
class AddFoodProductToFavouriteInitialState extends MerchantState {}

class AddFoodProductToFavouriteLoadingState extends MerchantState {
  const AddFoodProductToFavouriteLoadingState(this.id);

  final String id;
}

class AddFoodProductToFavouriteLoadedState extends MerchantState {
  const AddFoodProductToFavouriteLoadedState();
}

class AddFoodProductToFavouriteErrorState extends MerchantState {
  const AddFoodProductToFavouriteErrorState(this.message);

  final String message;
}

/// remove food product to favourite state
class RemoveFoodProductToFavouriteInitialState extends MerchantState {}

class RemoveFoodProductToFavouriteLoadingState extends MerchantState {
  const RemoveFoodProductToFavouriteLoadingState(this.id);
  final String id;
}

class RemoveFoodProductToFavouriteLoadedState extends MerchantState {
  const RemoveFoodProductToFavouriteLoadedState();
}

class RemoveFoodProductToFavouriteErrorState extends MerchantState {
  const RemoveFoodProductToFavouriteErrorState(this.message);

  final String message;
}

/// add food product to cart state
class AddFoodProductToCartInitialState extends MerchantState {}

class AddFoodProductToCartLoadingState extends MerchantState {
  const AddFoodProductToCartLoadingState(this.id);
  final String id;
}

class AddFoodProductToCartLoadedState extends MerchantState {}

class AddFoodProductToCartErrorState extends MerchantState {
  const AddFoodProductToCartErrorState(this.message);

  final String message;
}

/// add food product to cart state
class AddMarketItemToCartInitialState extends MerchantState {}

class AddMarketItemToCartLoadingState extends MerchantState {
  const AddMarketItemToCartLoadingState(this.id);
  final String id;
}

class AddMarketItemToCartLoadedState extends MerchantState {}

class AddMarketItemToCartErrorState extends MerchantState {
  const AddMarketItemToCartErrorState(this.message);

  final String message;
}

/// remove food product to cart state
class RemoveFoodProductToCartInitialState extends MerchantState {}

class RemoveFoodProductToCartLoadingState extends MerchantState {
  const RemoveFoodProductToCartLoadingState(this.id);
  final String id;
}

class RemoveFoodProductToCartLoadedState extends MerchantState {
  const RemoveFoodProductToCartLoadedState();
}

class RemoveFoodProductToCartErrorState extends MerchantState {
  const RemoveFoodProductToCartErrorState(this.message);

  final String message;
}

/// get cart item state
class GetCartItemInitialState extends MerchantState {}

class GetCartItemLoadingState extends MerchantState {}

class GetCartItemLoadedState extends MerchantState {
  const GetCartItemLoadedState(this.cartList);

  final List<CartModel> cartList;
}

class GetCartItemErrorState extends MerchantState {
  const GetCartItemErrorState(this.message);

  final String message;
}

/// get favourite item state
class GetFavouriteInitialState extends MerchantState {}

class GetFavouriteLoadingState extends MerchantState {}

class GetFavouriteLoadedState extends MerchantState {
  const GetFavouriteLoadedState(this.cartList);

  final List<FoodProductModel> cartList;
}

class GetFavouriteErrorState extends MerchantState {
  const GetFavouriteErrorState(this.message);

  final String message;
}

/// make payment for order state
class MakePaymentInitialState extends MerchantState {}

class MakePaymentLoadingState extends MerchantState {}

class MakePaymentLoadedState extends MerchantState {
  const MakePaymentLoadedState(this.id);

  final String id;
}

class MakePaymentErrorState extends MerchantState {
  const MakePaymentErrorState(this.message);

  final String message;
}

/// rate rider
class RateRiderInitialState extends MerchantState {}

class RateRiderLoadingState extends MerchantState {}

class RateRiderLoadedState extends MerchantState {}

class RateRiderErrorState extends MerchantState {
  const RateRiderErrorState(this.message);

  final String message;
}

/// search
class SearchInitialState extends MerchantState {}

class SearchLoadingState extends MerchantState {}

class SearchLoadedState extends MerchantState {
  const SearchLoadedState(this.search);
  final List<FoodProductModel> search;
}

class SearchErrorState extends MerchantState {
  const SearchErrorState(this.message);

  final String message;
}


/// search market
class SearchMarketInitialState extends MerchantState {}

class SearchMarketLoadingState extends MerchantState {}

class SearchMarketLoadedState extends MerchantState {
  const SearchMarketLoadedState(this.search);
  final List<MarketItemModel> search;
}

class SearchMarketErrorState extends MerchantState {
  const SearchMarketErrorState(this.message);

  final String message;
}

/// get market item
class GetMarketItemInitialState extends MerchantState {}

class GetMarketItemLoadingState extends MerchantState {}

class GetMarketItemLoadedState extends MerchantState {
  const GetMarketItemLoadedState(this.items);
  final List<MarketItemModel> items;
}

class GetMarketItemErrorState extends MerchantState {
  const GetMarketItemErrorState(this.message);

  final String message;
}
