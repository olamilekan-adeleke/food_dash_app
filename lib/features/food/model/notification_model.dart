import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';

class NotificationModel {
  NotificationModel({
    required this.body,
    required this.orderId,
    required this.userId,
    required this.timestamp,
    required this.items,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    final List<Map<String, dynamic>> itemsMap =
        List<Map<String, dynamic>>.from(map['items'] as List<dynamic>);

    final List<CartModel> items = itemsMap
        .map((Map<String, dynamic> e) =>
            CartModel.fromMap(e, e['id'].toString()))
        .toList();

    return NotificationModel(
      body: map['body'] as String,
      orderId: map['orderId'] as String,
      userId: map['userId'] as String,
      timestamp: map['timestamp'] as Timestamp,
      items: items,
    );
  }

  final String body;
  final String orderId;
  final String userId;
  final Timestamp timestamp;
  final List<CartModel> items;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'body': body,
      'orderId': orderId,
      'userId': userId,
      'timestamp': timestamp.toDate(),
      'items': items.map((CartModel e) => e.toMap()),
    };
  }

  

  String toJson() => json.encode(toMap());

  // factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source));
}
