// foodlocation.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodtracker_firebase/model/LocationMarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Remove the old foodLocationMarker function and replace it with this:
Widget buildFoodLocationMarkers(
  BuildContext context,
  MapController mapController,
) {
  return FutureBuilder<MarkerLayer>(
    future: _getMarkersFromFirestore(context, mapController),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Show loading or empty markers while fetching data
        return const MarkerLayer(markers: []);
      }

      if (snapshot.hasError) {
        print('Error fetching markers: ${snapshot.error}');
        return const MarkerLayer(markers: []);
      }

      return snapshot.data ?? const MarkerLayer(markers: []);
    },
  );
}

// Renamed the function to avoid confusion
Future<MarkerLayer> _getMarkersFromFirestore(
  BuildContext context,
  MapController mapController,
) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final QuerySnapshot snapshot = await firestore.collection('locations').get();

  List<Marker> markers = [];

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final locationMarker = LocationMarker.fromJson(data);

    // Convert GeoPoint to LatLng
    final latLng = LatLng(
      locationMarker.location.latitude,
      locationMarker.location.longitude,
    );

    // Determine icon color based on category
    final Color iconColor = _getIconColor(locationMarker.foodCategory);

    markers.add(
      Marker(
        point: latLng,
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker (keeping your 18.0 zoom level)
            mapController.move(
              latLng,
              18.0, // desired zoom level - KEEPING THIS AS REQUESTED
            );

            // 👇 Show modal
            _showMarkerInfo(
              context,
              locationMarker.foodName,
              locationMarker.foodCategory,
              _getRating(locationMarker.foodName),
            );
          },
          child: Icon(Icons.location_on, size: 40, color: iconColor),
        ),
      ),
    );
  }

  return MarkerLayer(markers: markers);
}

// Helper function to determine icon color based on category
Color _getIconColor(String category) {
  switch (category.toLowerCase()) {
    case 'barbecue restaurant':
    case 'eatery':
      return Colors.blue;
    case 'restaurant':
    case 'chinese restaurant':
    case 'filipino restaurant':
    case 'japanese restaurant':
      return Colors.red;
    case 'coffee shop':
    case 'bubble tea store':
      return Colors.brown;
    default:
      return Colors.blue;
  }
}

// Helper function to get ratings (you might want to store this in Firebase too)
double _getRating(String foodName) {
  // This is a temporary solution - you should store ratings in Firebase
  final ratings = {
    "Lala's Barbecue": 4.5,
    "Romeo's Sisigan sa Dakbayan": 4.3,
    "MCJACK Eatery": 4.0,
    "Slate Coffee + Deli": 3.8,
    "La Creme": 4.9,
    "827 Food Haus": 2.6,
    "ALBERT EATERY": 3.5,
    "Chachago - Davao Obrero": 3.1,
    "Davao Famous Restaurant - Obrero Branch": 4.4,
    "Man Made Davao": 4.6,
    "Binnamon and Coffee": 3.5,
    "Kairos Kitchen": 3.2,
    "Kambingan Ni Kuya": 4.5,
    "Rekado Filipino Comfort Cuisine": 5.0,
    "呑ん気 Nonki Japanese Restaurant - Davao, F. Torres Street": 4.8,
    "Balay Juice & Coffee Co.": 3.6,
    "Lecyl's Eatery": 4.6,
    "Ate Thel'z": 3.9,
    "Buffet 52": 4.2,
    "Tita Alm'z": 5.0,
  };

  return ratings[foodName] ?? 3.0;
}

void _showMarkerInfo(
  BuildContext context,
  String title,
  String description,
  double rating,
) {
  showBottomSheet(
    context: context,
    backgroundColor: const Color(0xff2f4a5d),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(color: Color(0xffffffff)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: rating,
                    itemBuilder: (context, index) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 24,
                    direction: Axis.horizontal,
                  ),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions, size: 20),
                    SizedBox(width: 8),
                    Text("Directions"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
