import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NavLocationPage extends StatefulWidget {
  const NavLocationPage({Key? key}) : super(key: key);

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
              initialCenter: LatLng(0, 0),
              initialZoom: 2,
              minZoom: 0,
              maxZoom: 100,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),
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
