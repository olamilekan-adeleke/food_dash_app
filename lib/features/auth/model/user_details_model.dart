import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_dash_app/features/food/model/location_details.dart';

class UserDetailsModel {
  UserDetailsModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.profilePicUrl,
    this.address,
    this.region,
    this.dateJoined,
    this.location,
    required this.walletBalance,
  });

  factory UserDetailsModel.fromMap(Map<String, dynamic>? map) {
    return UserDetailsModel(
      uid: map!['uid'].toString(),
      email: map['email'].toString(),
      fullName: map['full_name'].toString(),
      address: map['address'] != null ? map['address'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      walletBalance: map['wallet_balance'] != null
          ? double.parse(map['wallet_balance'].toString())
          : 0.0,
      phoneNumber: map['phone_number'] != null ? map['phone_number'] as int : 0,
      profilePicUrl: map['profile_pic_url'] != null
          ? map['profile_pic_url'] as String
          : null,
      dateJoined:
          map['date_joined'] != null ? map['date_joined'] as Timestamp : null,
      location: map['location'] != null
          ? Suggestion.fromMap(Map<String, dynamic>.from(map['location']))
          : null,
    );
  } // 507850785078507812

  factory UserDetailsModel.fromJson(String source) =>
      UserDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String uid;
  final String email;
  final String fullName;
  final String? address;
  final String? region;
  final int phoneNumber;
  final String? profilePicUrl;
  final Timestamp? dateJoined;
  final double? walletBalance;
  final Suggestion? location;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'profile_pic_url': profilePicUrl,
      'date_joined': dateJoined,
      'address': address,
      'region': region,
      'location': location?.toMap(),
    };
  }

  Map<String, dynamic> toMapForLocalDb() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'profile_pic_url': profilePicUrl,
      'address': address,
      'region': region,
      'location': location?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  UserDetailsModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? address,
    String? region,
    int? phoneNumber,
    String? profilePicUrl,
    Timestamp? dateJoined,
    double? walletBalance,
    Suggestion? location,
  }) {
    return UserDetailsModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      dateJoined: dateJoined ?? this.dateJoined,
      walletBalance: walletBalance ?? this.walletBalance,
      address: address ?? this.address,
      region: region ?? this.region,
      location: location ?? this.location,
    );
  }
}
