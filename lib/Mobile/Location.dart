import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NavLocationPage extends StatefulWidget {
  const NavLocationPage({super.key});

  @override
  State<NavLocationPage> createState() => _NavLocationPageState();
}

class _NavLocationPageState extends State<NavLocationPage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
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
        ],
      ),
    );
  }
}
