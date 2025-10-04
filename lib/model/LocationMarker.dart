import 'package:cloud_firestore/cloud_firestore.dart';

class LocationMarker {
  final GeoPoint location;
  final String foodName;
  final String foodCategory;
  final String foodDescription;

  LocationMarker({
    required this.location,
    required this.foodName,
    required this.foodCategory,
    required this.foodDescription,
  });
  Map<String, dynamic> toJson() => {
    'location': location,
    'foodName': foodName,
    'foodCategory': foodCategory,
    'foodDescription': foodDescription,
  };
  static LocationMarker fromJson(Map<String, dynamic> json) => LocationMarker(
    location: json['location'] ?? GeoPoint(0, 0),
    foodName: json['foodName'] ?? '',
    foodCategory: json['foodCategory'] ?? '',
    foodDescription: json['foodDescription'] ?? '',
  );
}
