import 'dart:convert';

class MerchantModel {
  const MerchantModel({
    required this.name,
    required this.image,
    required this.categories,
    required this.rating,
    required this.numberOfRating,
  });

  factory MerchantModel.fromMap(Map<String, dynamic> map) {
    return MerchantModel(
      name: map['name'] as String,
      image: map['image'] as String,
      categories: List<String>.from(map['categories'] as List<String>),
      rating: map['rating'] as double,
      numberOfRating: map['numberOfRating'] as int,
    );
  }

  factory MerchantModel.fromJson(String source) =>
      MerchantModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String name;
  final String image;
  final List<String> categories;
  final double rating;
  final int numberOfRating;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'categories': categories,
      'rating': rating,
      'numberOfRating': numberOfRating,
    };
  }

  String toJson() => json.encode(toMap());
}
