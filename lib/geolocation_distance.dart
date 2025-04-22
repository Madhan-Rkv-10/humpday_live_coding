import 'package:geolocator/geolocator.dart';

void main() async {
  // Example coordinates (current location and new location)
  double currentLat = 12.912390922531637; // Latitude of your current location
  double currentLon = 77.64005750468513; // Longitude of your current location

  double newLat = 12.912884236878199; // Latitude of the new location
  double newLon = 77.64021052827597; // Longitude of the new location

  // Calculate the distance
  double distance = Geolocator.distanceBetween(
    currentLat,
    currentLon,
    newLat,
    newLon,
  );

  // Check if the distance is within 100 meters
  if (distance <= 100) {
    print(
      "The new location is within 100 meters (Distance: $distance meters).",
    );
  } else {
    print(
      "The new location is NOT within 100 meters (Distance: $distance meters).",
    );
  }
}
