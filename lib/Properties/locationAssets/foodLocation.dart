// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong2/latlong.dart';

MarkerLayer foodLocationMarker(
  BuildContext context,
  MapController mapController,
) {
  return MarkerLayer(
    markers: [
      // #1 Lala's Barbecue
      Marker(
        point: const LatLng(7.083888309188104, 125.61506318990922),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.083888309188104, 125.61506318990922),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(
              context,
              "Lala's Barbecue",
              "Barbecue restaurant",
              4.5,
            );
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #2 Romeo's Sisigan sa Dakbayan
      Marker(
        point: const LatLng(7.082690273808564, 125.61609557328308),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.082690273808564, 125.61609557328308),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(
              context,
              "Romeo's Sisigan sa Dakbayan",
              "Restaurant",
              4.3,
            );
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #3 MCJACK Eatery
      Marker(
        point: const LatLng(7.082489552467615, 125.61660391025664),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.082489552467615, 125.61660391025664),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "MCJACK Eatery", "Eatery", 4.0);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #4 Slate Coffee + Deli
      Marker(
        point: const LatLng(7.0847073063888795, 125.61654806866731),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.0847073063888795, 125.61654806866731),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Slate Coffee + Deli", "Coffee Shop", 3.8);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #5 La Creme
      Marker(
        point: const LatLng(7.083581028480803, 125.61466813763387),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.083581028480803, 125.61466813763387),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "La Creme", "Coffee shop", 4.9);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #6 827 Food Haus
      Marker(
        point: const LatLng(7.084137701195023, 125.61321053199362),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.084137701195023, 125.61321053199362),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "827 Food Haus", "Eatery", 2.6);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #7 ALBERT EATERY
      Marker(
        point: const LatLng(7.085768728887017, 125.61419047058223),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.085768728887017, 125.61419047058223),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "ALBERT EATERY", "Eatery", 3.5);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #8 Chachago - Davao Obrero
      Marker(
        point: const LatLng(7.082559371783049, 125.6168071956497),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.082559371783049, 125.6168071956497),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(
              context,
              "Chachago - Davao Obrero",
              "Bubble tea store",
              3.1,
            );
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
        //
      ),

      // #9 Davao Famous Restaurant - Obrero Branch
      Marker(
        point: const LatLng(7.0821176941030375, 125.61483837393249),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.0821176941030375, 125.61483837393249),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(
              context,
              "Davao Famous Restaurant - Obrero Branch",
              "Chinese Restaurant",
              4.4,
            );
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #10 Man Made Davao
      Marker(
        point: const LatLng(7.084559771896441, 125.61622026093909),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.084559771896441, 125.61622026093909),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Man Made Davao", "Coffee shop", 4.6);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #11 Binnamon and Coffee
      Marker(
        point: const LatLng(7.084257245525749, 125.61519825024642),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.084257245525749, 125.61519825024642),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Binnamon and Coffee", "Coffee Shop", 3.5);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #12 Kairos Kitchen
      Marker(
        point: const LatLng(7.0885318600201765, 125.61780901760001),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.0885318600201765, 125.61780901760001),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Kairos Kitchen", "Restaurent", 3.2);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #13 Kambingan Ni Kuya
      Marker(
        point: const LatLng(7.085121620542566, 125.6187857591029),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.085121620542566, 125.6187857591029),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Kambingan Ni Kuya", "Eatery", 4.5);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #14 Rekado Filipino Comfort Cuisine
      Marker(
        point: const LatLng(7.078374410072211, 125.60910181431184),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.078374410072211, 125.60910181431184),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(
              context,
              "Rekado Filipino Comfort Cuisine",
              "Filipino restaurant",
              5.0,
            );
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #15 呑ん気 Nonki Japanese Restaurant - Davao, F. Torres Street
      Marker(
        point: const LatLng(7.081724962427516, 125.61016662573661),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.081724962427516, 125.61016662573661),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(
              context,
              "呑ん気 Nonki Japanese Restaurant - Davao, F. Torres Street",
              "Japanese restaurant",
              4.8,
            );
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #16 Balay Juice & Coffee Co.
      Marker(
        point: const LatLng(7.081575076409046, 125.61426586784411),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.081575076409046, 125.61426586784411),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(
              context,
              "Balay Juice & Coffee Co.",
              "Coffee Shop",
              3.6,
            );
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #17 Lecyl's Eatery
      Marker(
        point: const LatLng(7.086673689445712, 125.61336600245534),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.086673689445712, 125.61336600245534),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Lecyl's Eatery", "Eatery", 4.6);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #18 Ate Thel'z
      Marker(
        point: const LatLng(7.082929188675741, 125.61382465757832),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.082929188675741, 125.61382465757832),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Ate Thel'z", "Eatery", 3.9);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #19 Buffet 52
      Marker(
        point: const LatLng(7.081836439982566, 125.61194252743832),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.081836439982566, 125.61194252743832),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Buffet 52", "Restaurant", 4.2);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #20 Tita Alm'z BBQ
      Marker(
        point: const LatLng(7.085857911220809, 125.6133520077113),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            // 👇 Zoom + center on marker
            mapController.move(
              const LatLng(7.085857911220809, 125.6133520077113),
              18.0, // desired zoom level
            );

            // 👇 Show modal
            _showMarkerInfo(context, "Tita Alm'z", "Barbecue eatery", 5.0);
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),
    ],
  );
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
      height: 200,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //First Column for details
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
                  // ⭐ Rating Stars
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
                  mainAxisSize: MainAxisSize.min, // keep button compact
                  children: [
                    Icon(Icons.directions, size: 20), // leading icon
                    SizedBox(width: 8), // spacing
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
