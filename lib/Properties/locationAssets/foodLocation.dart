import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

MarkerLayer foodLocationMarker(BuildContext context) {
  return MarkerLayer(
    markers: [
      // #1 Lala's Barbecue
      Marker(
        point: const LatLng(7.083888309188104, 125.61506318990922),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(
            context,
            "Lala's Barbecue",
            "Barbecue restaurant",
          ),
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #2 Romeo's Sisigan sa Dakbayan
      Marker(
        point: const LatLng(7.082690273808564, 125.61609557328308),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(
            context,
            "Romeo's Sisigan sa Dakbayan",
            "Restaurant",
          ),
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #3 MCJACK Eatery
      Marker(
        point: const LatLng(7.082489552467615, 125.61660391025664),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "MCJACK Eatery", "Eatery"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #4 Slate Coffee + Deli
      Marker(
        point: const LatLng(7.0847073063888795, 125.61654806866731),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () =>
              _showMarkerInfo(context, "Slate Coffee + Deli", "Coffee Shop"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #5 La Creme
      Marker(
        point: const LatLng(7.083581028480803, 125.61466813763387),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "La Creme", "Coffee shop"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #6 827 Food Haus
      Marker(
        point: const LatLng(7.084137701195023, 125.61321053199362),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "827 Food Haus", "Eatery"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #7 ALBERT EATERY
      Marker(
        point: const LatLng(7.085768728887017, 125.61419047058223),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "ALBERT EATERY", "Eatery"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #8 Chachago - Davao Obrero
      Marker(
        point: const LatLng(7.082559371783049, 125.6168071956497),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(
            context,
            "Chachago - Davao Obrero",
            "Bubble tea store",
          ),
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #9 Davao Famous Restaurant - Obrero Branch
      Marker(
        point: const LatLng(7.0821176941030375, 125.61483837393249),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(
            context,
            "Davao Famous Restaurant - Obrero Branch",
            "Chinese Restaurant",
          ),
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #10 Man Made Davao
      Marker(
        point: const LatLng(7.084559771896441, 125.61622026093909),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () =>
              _showMarkerInfo(context, "Man Made Davao", "Coffee shop"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #11 Binnamon and Coffee
      Marker(
        point: const LatLng(7.084257245525749, 125.61519825024642),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () =>
              _showMarkerInfo(context, "Binnamon and Coffee", "Coffee Shop"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #12 Kairos Kitchen
      Marker(
        point: const LatLng(7.0885318600201765, 125.61780901760001),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "Kairos Kitchen", "Restaurent"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #13 Kambingan Ni Kuya
      Marker(
        point: const LatLng(7.085121620542566, 125.6187857591029),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "Kambingan Ni Kuya", "Eatery"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #14 Rekado Filipino Comfort Cuisine
      Marker(
        point: const LatLng(7.078374410072211, 125.60910181431184),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(
            context,
            "Rekado Filipino Comfort Cuisine",
            "Filipino restaurant",
          ),
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #15 呑ん気 Nonki Japanese Restaurant - Davao, F. Torres Street
      Marker(
        point: const LatLng(7.081724962427516, 125.61016662573661),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(
            context,
            "呑ん気 Nonki Japanese Restaurant - Davao, F. Torres Street",
            "Japanese restaurant",
          ),
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #16 Balay Juice & Coffee Co.
      Marker(
        point: const LatLng(7.081575076409046, 125.61426586784411),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(
            context,
            "Balay Juice & Coffee Co.",
            "Coffee Shop",
          ),
          child: const Icon(Icons.location_on, size: 40, color: Colors.brown),
        ),
      ),

      // #17 Lecyl's Eatery
      Marker(
        point: const LatLng(7.086673689445712, 125.61336600245534),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "Lecyl's Eatery", "Eatery"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #18 Ate Thel'z
      Marker(
        point: const LatLng(7.082929188675741, 125.61382465757832),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "Ate Thel'z", "Eatery"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.blue),
        ),
      ),

      // #19 Buffet 52
      Marker(
        point: const LatLng(7.081836439982566, 125.61194252743832),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, "Buffet 52", "Restaurant"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),

      // #20 Tita Alm'z BBQ
      Marker(
        point: const LatLng(7.085857911220809, 125.6133520077113),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () =>
              _showMarkerInfo(context, "Tita Alm'z", "Barbecue eatery"),
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ),
    ],
  );
}

void _showMarkerInfo(BuildContext context, String title, String description) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(description),
        ],
      ),
    ),
  );
}
