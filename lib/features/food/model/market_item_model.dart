import 'dart:convert';

class MarketItemModel {
  MarketItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.category,
    required this.price,
  });

  factory MarketItemModel.fromMap(Map<String, dynamic> map) {
    return MarketItemModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      images: List<String>.from(map['images']),
      category: map['category'],
      price: map['price'],
    );
  }

  factory MarketItemModel.fromJson(String source) =>
      MarketItemModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  final String id;
  final String name;
  final String description;
  final List<String> images;
  final String category;
  final int price;

  Map<String, dynamic> toMap() {
    final List<String> searchKey = <String>[];
    final List<String> splitedNames = name.split(' ');
    String currentItem = '';

    for (int i = 0; i < splitedNames.length; i++) {
      splitedNames[i].split('').toList().forEach((String element) {
        currentItem += element;
        searchKey.add(currentItem);
      });

      currentItem = '';
      searchKey.add(currentItem);
    }

    name.split('').toList().forEach((String element) {
      currentItem += element;
      searchKey.add(currentItem);
    });

    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'category': category,
      'price': price,
      'search_key': searchKey.toSet().toList(),
      'count': 0,
    };
  }
}
