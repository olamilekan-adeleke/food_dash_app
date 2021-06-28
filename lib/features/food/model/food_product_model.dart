import 'dart:convert';

class FoodProductModel {
  const FoodProductModel({
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
  });

  factory FoodProductModel.fromMap(Map<String, dynamic> map) {
    return FoodProductModel(
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      category: map['category'] as String,
      price: map['price'] as int,
    );
  }

  factory FoodProductModel.fromJson(String source) =>
      FoodProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String name;
  final String description;
  final String image;
  final String category;
  final int price;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'price': price,
    };
  }

  String toJson() => json.encode(toMap());
}
