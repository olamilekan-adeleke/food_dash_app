import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/extenions.dart';

import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';

class OrderModel {
  const OrderModel({
    required this.items,
    this.timestamp,
    required this.userDetails,
    required this.id,
    required this.type,
    required this.itemsFee,
    required this.deliveryFee,
    this.orderStatus,
    this.restaurantsList,
    this.riderDetails,
    this.hasRated,
    this.userId,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final List<CartModel> items =
        List<Map<String, dynamic>>.from(map['items'] as List<dynamic>)
            .map((Map<String, dynamic> data) =>
                CartModel.fromMap(data, data['id'] as String))
            .toList();

    final UserDetailsModel userDetails =
        UserDetailsModel.fromMap(map['user_details'] as Map<String, dynamic>);

    return OrderModel(
      items: items,
      timestamp: map['timestamp'] as Timestamp,
      userDetails: userDetails,
      id: map['id'] as String,
      type: map['type'] as String,
      restaurantsList: List<String>.from(
        map['restaurants_list'] as List<dynamic>,
      ),
      orderStatus: OrderStatusExtension.stringToEunm(
        map['order_status'] as String,
      ),
      riderDetails: map['rider_details'] != null
          ? UserDetailsModel.fromMap(
              map['rider_details'] as Map<String, dynamic>,
            )
          : null,
      hasRated: map['has_rated'] as bool,
      itemsFee: (map['items_fee'] ?? 0) as int,
      deliveryFee: (map['delivery_fee'] ?? 0) as int,
    );
  }

  final List<CartModel> items;
  final Timestamp? timestamp;
  final UserDetailsModel userDetails;
  final String id;
  final String type;
  final String? userId;
  final List<String>? restaurantsList;
  final OrderStatusEunm? orderStatus;
  final UserDetailsModel? riderDetails;
  final bool? hasRated;
  final int itemsFee;
  final int deliveryFee;

  Map<String, dynamic> toMap() {
    final Set<String> _restaurantsList = <String>{};

    items.toList().forEach((CartModel element) {
      _restaurantsList.add(element.fastFoodName ?? 'Fast food name');
    });

    return <String, dynamic>{
      'items': items.map((CartModel cart) => cart.toMapForLocalDb()).toList(),
      'timestamp': timestamp ?? Timestamp.now(),
      'user_details': userDetails.toMap(),
      'user_id': userDetails.uid,
      'id': id,
      'type': type,
      'restaurants_list': _restaurantsList.toList(),
      'order_status': OrderStatusExtension.eumnToString(
        orderStatus ?? OrderStatusEunm.pending,
      ),
      'rider_details': null,
      'has_rated': hasRated ?? false,
      'items_fee': itemsFee,
      'delivery_fee': deliveryFee,
    };
  }
}
