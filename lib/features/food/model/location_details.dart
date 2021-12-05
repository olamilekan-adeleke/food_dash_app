import 'dart:convert';

class Suggestion {
  final String placeId;
  final String description;
  final String title;

  Suggestion(this.placeId, this.description, this.title);

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'description': description,
      'title': title,
    };
  }

  factory Suggestion.fromMap(Map<String, dynamic> map) {
    return Suggestion(
      map['placeId'],
      map['description'],
      map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Suggestion.fromJson(String source) => Suggestion.fromMap(json.decode(source));
}

class PlaceDetail {
  String? address;
  double? latitude;
  double? longitude;
  String? name;

  PlaceDetail({
    this.address,
    this.latitude,
    this.longitude,
    this.name,
  });
}
