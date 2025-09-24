import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foodtracker_firebase/Properties/locationAssets/foodLocation.dart';
import 'package:latlong2/latlong.dart';

class NavLocationPage extends StatefulWidget {
  const NavLocationPage({super.key});

  @override
  State<NavLocationPage> createState() => _NavLocationPageState();
}

class _NavLocationPageState extends State<NavLocationPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAP BEHIND
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(7.082414628289476, 125.61406854129964),
              initialZoom: 16,
              minZoom: 2,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),

              // 🔹 Call Markerlayer here
              foodLocationMarker(context),
            ],
          ),

          /// SEARCH BAR IN FRONT
          Positioned(
            top: 40, // distance from top of screen
            left: 20,
            right: 20,
            child: Row(
              children: [
                /// TextField for search input
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search location...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        icon: const Icon(Icons.search, color: Colors.blue),
                        onPressed: () {
                          // TODO: implement search logic
                          print("Searching for: ${_searchController.text}");
                        },
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
