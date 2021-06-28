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
