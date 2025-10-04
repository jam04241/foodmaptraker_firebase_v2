// foodlocation.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foodtracker_firebase/model/LocationMarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Updated function with navigation callbacks
Widget buildFoodLocationMarkers(
  BuildContext context,
  MapController mapController, {
  required Function(LatLng, String) onDirectionsPressed,
  required bool isNavigating,
}) {
  return FutureBuilder<MarkerLayer>(
    future: _getMarkersFromFirestore(
      context,
      mapController,
      onDirectionsPressed,
      isNavigating,
    ),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
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

Future<MarkerLayer> _getMarkersFromFirestore(
  BuildContext context,
  MapController mapController,
  Function(LatLng, String) onDirectionsPressed,
  bool isNavigating,
) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final QuerySnapshot snapshot = await firestore.collection('locations').get();

  List<Marker> markers = [];

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final locationMarker = LocationMarker.fromJson(data);

    final latLng = LatLng(
      locationMarker.location.latitude,
      locationMarker.location.longitude,
    );

    final Color iconColor = _getIconColor(locationMarker.foodCategory);

    markers.add(
      Marker(
        point: latLng,
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // Zoom to marker
            mapController.move(latLng, 18.0);

            // Show info modal
            _showMarkerInfo(
              context,
              locationMarker.foodName,
              locationMarker.foodCategory,
              latLng,
              onDirectionsPressed,
              isNavigating,
            );
          },
          child: Icon(Icons.location_on, size: 40, color: iconColor),
        ),
      ),
    );
  }

  return MarkerLayer(markers: markers);
}

// Enhanced bottom sheet with navigation and image carousel
void _showMarkerInfo(
  BuildContext context,
  String title,
  String description,
  LatLng location,
  Function(LatLng, String) onDirectionsPressed,
  bool isNavigating,
) {
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.transparent,
    backgroundColor: const Color(0xff2f4a5d),
    isDismissible: !isNavigating,
    enableDrag: !isNavigating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      height: 400, // Increased height for images
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button - ALWAYS VISIBLE
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // IMAGE CAROUSEL SPACE - Simple vertical slide
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[800]!.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: PageView(
              scrollDirection: Axis.horizontal, // This makes it vertical
              children: [
                // Food 2
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('images/food2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Food 3
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('images/food3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Food 4
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('images/food4.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Dynamic button based on navigation state
          if (isNavigating)
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Complete your current navigation first!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, size: 20),
                  SizedBox(width: 8),
                  Text("Already Navigating", style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close bottom sheet
                onDirectionsPressed(location, title); // Start navigation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions, size: 24),
                  SizedBox(width: 8),
                  Text("Start Navigation", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

// Existing helper functions
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
