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
