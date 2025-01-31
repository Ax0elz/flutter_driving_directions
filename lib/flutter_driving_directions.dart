import 'flutter_driving_directions_platform_interface.dart';

class FlutterDrivingDirections {
  static Future<void> launchDirections({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    return FlutterDrivingDirectionsPlatform.instance.launchDirections(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }

  static Future<void> launchDirectionsToAddress({
    required String address,
  }) {
    return FlutterDrivingDirectionsPlatform.instance.launchDirectionsToAddress(
      address: address,
    );
  }

  static Future<List<Map<String, dynamic>>> getDirectionsPolylines({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    TransportTypeEnum? transportType,
  }) async {
    return FlutterDrivingDirectionsPlatform.instance.getDirectionsPolylines(
      fromLat: fromLat,
      fromLng: fromLng,
      toLat: toLat,
      toLng: toLng,
      transportType: transportType,
    );
  }
}

enum TransportTypeEnum {
  driving,
  walking,
  bicycling,
  transit,
}
