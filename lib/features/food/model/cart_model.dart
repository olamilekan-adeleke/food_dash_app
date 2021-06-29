import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  const CartModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
    required this.count,
    this.timestamp,
  }) ;

  factory CartModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return CartModel(
      id: documentId,
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      category: map['category'] as String,
      price: map['price'] as int,
      count: map['count'] as int,
      timestamp: map['timestamp'] as Timestamp,
      
    );
  }

  final String id;
  final String name;
  final String description;
  final String image;
  final String category;
  final int price;
  final int count;
  final Timestamp? timestamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'price': price,
      'count': count,
      'timestamp': timestamp ?? Timestamp.now(),
    };
  }

  String toJson() => json.encode(toMap());
}