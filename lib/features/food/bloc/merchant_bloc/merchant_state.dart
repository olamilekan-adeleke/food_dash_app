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
