// firebase_upload_script.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'LocationMarker.dart';

class FirebaseUploader {
  static Future<void> uploadLocationsToFirebase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Check if data already exists
    final snapshot = await firestore.collection('locations').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('📍 Locations already exist in Firebase. Skipping upload.');
      return;
    }

    // Your location data
    List<LocationMarker> locations = [
      // #1 Lala's Barbecue
      LocationMarker(
        location: GeoPoint(7.083888309188104, 125.61506318990922),
        foodName: "Lala's Barbecue",
        foodCategory: "Barbecue restaurant",
        foodDescription: 'null',
      ),

      // #2 Romeo's Sisigan sa Dakbayan
      LocationMarker(
        location: GeoPoint(7.082690273808564, 125.61609557328308),
        foodName: "Romeo's Sisigan sa Dakbayan",
        foodCategory: "Restaurant",
        foodDescription: 'null',
      ),

      // #3 MCJACK Eatery
      LocationMarker(
        location: GeoPoint(7.082489552467615, 125.61660391025664),
        foodName: "MCJACK Eatery",
        foodCategory: "Eatery",
        foodDescription: 'null',
      ),

      // #4 Slate Coffee + Deli
      LocationMarker(
        location: GeoPoint(7.0847073063888795, 125.61654806866731),
        foodName: "Slate Coffee + Deli",
        foodCategory: "Coffee Shop",
        foodDescription: 'null',
      ),

      // #5 La Creme
      LocationMarker(
        location: GeoPoint(7.083581028480803, 125.61466813763387),
        foodName: "La Creme",
        foodCategory: "Coffee shop",
        foodDescription: 'null',
      ),

      // #6 827 Food Haus
      LocationMarker(
        location: GeoPoint(7.084137701195023, 125.61321053199362),
        foodName: "827 Food Haus",
        foodCategory: "Eatery",
        foodDescription: 'null',
      ),

      // #7 ALBERT EATERY
      LocationMarker(
        location: GeoPoint(7.085768728887017, 125.61419047058223),
        foodName: "ALBERT EATERY",
        foodCategory: "Eatery",
        foodDescription: 'null',
      ),

      // #8 Chachago - Davao Obrero
      LocationMarker(
        location: GeoPoint(7.082559371783049, 125.6168071956497),
        foodName: "Chachago - Davao Obrero",
        foodCategory: "Bubble tea store",
        foodDescription: 'null',
      ),

      // #9 Davao Famous Restaurant - Obrero Branch
      LocationMarker(
        location: GeoPoint(7.0821176941030375, 125.61483837393249),
        foodName: "Davao Famous Restaurant - Obrero Branch",
        foodCategory: "Chinese Restaurant",
        foodDescription: 'null',
      ),

      // #10 Man Made Davao
      LocationMarker(
        location: GeoPoint(7.084559771896441, 125.61622026093909),
        foodName: "Man Made Davao",
        foodCategory: "Coffee shop",
        foodDescription: 'null',
      ),

      // #11 Binnamon and Coffee
      LocationMarker(
        location: GeoPoint(7.084257245525749, 125.61519825024642),
        foodName: "Binnamon and Coffee",
        foodCategory: "Coffee Shop",
        foodDescription: 'null',
      ),

      // #12 Kairos Kitchen
      LocationMarker(
        location: GeoPoint(7.0885318600201765, 125.61780901760001),
        foodName: "Kairos Kitchen",
        foodCategory: "Restaurent",
        foodDescription: 'null',
      ),

      // #13 Kambingan Ni Kuya
      LocationMarker(
        location: GeoPoint(7.085121620542566, 125.6187857591029),
        foodName: "Kambingan Ni Kuya",
        foodCategory: "Eatery",
        foodDescription: 'null',
      ),

      // #14 Rekado Filipino Comfort Cuisine
      LocationMarker(
        location: GeoPoint(7.078374410072211, 125.60910181431184),
        foodName: "Rekado Filipino Comfort Cuisine",
        foodCategory: "Filipino restaurant",
        foodDescription: 'null',
      ),

      // #15 呑ん気 Nonki Japanese Restaurant - Davao, F. Torres Street
      LocationMarker(
        location: GeoPoint(7.081724962427516, 125.61016662573661),
        foodName: "呑ん気 Nonki Japanese Restaurant - Davao, F. Torres Street",
        foodCategory: "Japanese restaurant",
        foodDescription: 'null',
      ),

      // #16 Balay Juice & Coffee Co.
      LocationMarker(
        location: GeoPoint(7.081575076409046, 125.61426586784411),
        foodName: "Balay Juice & Coffee Co.",
        foodCategory: "Coffee Shop",
        foodDescription: 'null',
      ),

      // #17 Lecyl's Eatery
      LocationMarker(
        location: GeoPoint(7.086673689445712, 125.61336600245534),
        foodName: "Lecyl's Eatery",
        foodCategory: "Eatery",
        foodDescription: 'null',
      ),

      // #18 Ate Thel'z
      LocationMarker(
        location: GeoPoint(7.082929188675741, 125.61382465757832),
        foodName: "Ate Thel'z",
        foodCategory: "Eatery",
        foodDescription: 'null',
      ),

      // #19 Buffet 52
      LocationMarker(
        location: GeoPoint(7.081836439982566, 125.61194252743832),
        foodName: "Buffet 52",
        foodCategory: "Restaurant",
        foodDescription: 'null',
      ),

      // #20 Tita Alm'z BBQ
      LocationMarker(
        location: GeoPoint(7.085857911220809, 125.6133520077113),
        foodName: "Tita Alm'z",
        foodCategory: "Barbecue eatery",
        foodDescription: 'null',
      ),
    ];

    // Upload to Firebase
    for (int i = 0; i < locations.length; i++) {
      await firestore
          .collection('locations')
          .doc('location_${i + 1}')
          .set(locations[i].toJson());
    }

    print(
      '✅ All ${locations.length} locations uploaded to Firebase successfully!',
    );
  }
}
