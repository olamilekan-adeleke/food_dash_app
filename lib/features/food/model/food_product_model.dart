import 'dart:convert';

class FoodProductModel {
  const FoodProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
  });

  factory FoodProductModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return FoodProductModel(
      id: documentId,
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      category: map['category'] as String,
      price: map['price'] as int,
    );
  }

  final String id;
  final String name;
  final String description;
  final String image;
  final String category;
  final int price;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'price': price,
    };
  }

  String toJson() => json.encode(toMap());
}
