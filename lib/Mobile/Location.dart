// Location.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foodtracker_firebase/Properties/locationAssets/foodLocation.dart';
import 'package:latlong2/latlong.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NavLocationPage extends StatefulWidget {
  const NavLocationPage({super.key});

  @override
  State<NavLocationPage> createState() => _NavLocationPageState();
}

class _NavLocationPageState extends State<NavLocationPage> {
  late final MapController _mapController;
  final TextEditingController _searchController = TextEditingController();

  // Navigation state variables
  LatLng? _selectedLocation;
  String? _selectedLocationName;
  List<LatLng> _polylinePoints = [];
  bool _isNavigating = false;
  bool _hasArrived = false;
  Timer? _navigationTimer;

  // Manual current location (simulated)
  LatLng _currentLocation = const LatLng(7.082414628289476, 125.61406854129964);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel(); // Clean up timer
    super.dispose();
  }

  // Start navigation to selected location
  void _startNavigation(LatLng destination, String locationName) {
    setState(() {
      _selectedLocation = destination;
      _selectedLocationName = locationName;
      _isNavigating = true;
      _hasArrived = false;
      _polylinePoints = [_currentLocation, destination];
    });
  }

  // Complete navigation
  void _completeNavigation() {
    setState(() {
      _isNavigating = false;
      _polylinePoints = [];
      _selectedLocation = null;
      _hasArrived = false;
    });
    _navigationTimer?.cancel();
  }

  // Check button pressed - user confirms they arrived
  void _onCheckButtonPressed() {
    _showCongratulationsSheet();
  }

  // Show congratulations when user arrives
  void _showCongratulationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Remove background dim
      isScrollControlled: true, // ✅ Allow full width expansion
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(
          horizontal: 0,
        ), // ✅ Remove horizontal margins
        width: double.infinity, // ✅ Expand to full width
        decoration: const BoxDecoration(
          color: Color(0xff2f4a5d),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ Only take needed height
          children: [
            const Icon(Icons.celebration, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'Congratulations! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity, // ✅ Expand text container to full width
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'You successfully reached $_selectedLocationName!',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // ✅ Expand button to full width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close congrats sheet
                  _completeNavigation(); // Reset navigation state
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text('Awesome! Continue Exploring'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Manual current location marker
  Marker _buildCurrentLocationMarker() {
    return Marker(
      point: _currentLocation,
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing circle effect
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
          ),
          // Location icon
          const Icon(Icons.location_on, color: Colors.blue, size: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 16,
              minZoom: 2,
              maxZoom: 19,
            ),
            children: [
              // Base map layer
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),

              // Polyline layer for navigation route
              if (_polylinePoints.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _polylinePoints,
                      color: Colors.blue.withOpacity(0.7),
                      strokeWidth: 6,
                      borderColor: Colors.white.withOpacity(0.5),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),

              // Food location markers
              buildFoodLocationMarkers(
                context,
                _mapController,
                onDirectionsPressed: _startNavigation,
                isNavigating: _isNavigating,
              ),

              // Manual current location marker
              MarkerLayer(markers: [_buildCurrentLocationMarker()]),
            ],
          ),

          /// SEARCH BAR
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search for restaurants, cafes...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _isNavigating
                      ? IconButton(
                          icon: const Icon(Icons.navigation, color: Colors.red),
                          onPressed: _completeNavigation,
                          tooltip: 'Stop Navigation',
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) {
                  print("Searching for: $value");
                  // TODO: Implement search logic
                },
              ),
            ),
          ),

          // Navigation status indicator
          if (_isNavigating)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasArrived ? Icons.check_circle : Icons.navigation,
                      color: _hasArrived ? Colors.green : Colors.blue,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _hasArrived ? 'You have arrived!' : 'Navigating...',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _selectedLocationName ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CHECK BUTTON - User confirms they arrived
                    if (!_hasArrived)
                      Container(
                        child: IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 28,
                          ),
                          onPressed: _onCheckButtonPressed,
                          tooltip: 'I have arrived at this location',
                        ),
                      ),

                    const SizedBox(width: 8),

                    // CLOSE/CANCEL BUTTON
                    IconButton(
                      icon: Icon(
                        _hasArrived ? Icons.close : Icons.close,
                        color: _hasArrived ? Colors.grey : Colors.red,
                      ),
                      onPressed: _completeNavigation,
                      tooltip: _hasArrived ? 'Close' : 'Cancel Navigation',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      // Floating action button to reset position (for testing)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentLocation = const LatLng(
              7.082414628289476,
              125.61406854129964,
            );
            _completeNavigation();
          });
        },
        child: const Icon(Icons.my_location),
        tooltip: 'Reset to Initial Position',
      ),
    );
  }
}
