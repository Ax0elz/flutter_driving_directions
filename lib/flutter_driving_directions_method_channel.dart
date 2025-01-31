import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driving_directions/flutter_driving_directions.dart';

import 'flutter_driving_directions_platform_interface.dart';

/// An implementation of [FlutterDrivingDirectionsPlatform] that uses method channels.
class MethodChannelFlutterDrivingDirections
    extends FlutterDrivingDirectionsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_driving_directions');

  @override
  Future<void> launchDirections({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    return await methodChannel.invokeMethod(
      'launchDirections',
      <String, Object>{
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      },
    );
  }

  @override
  Future<List<Map<String, double>>> getDirectionsPolylines({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    TransportTypeEnum? transportType,
  }) async {
    try {
      final coords = await methodChannel.invokeMethod<List<dynamic>>(
        'getDirectionsPolylines',
        <String, Object>{
          'fromLat': fromLat,
          'fromLng': fromLng,
          'toLat': toLat,
          'toLng': toLng,
          'transportType':
              transportType?.name ?? TransportTypeEnum.walking.name,
        },
      );
      return coords!
          .map((c) => {"latitude": c["latitude"], "longitude": c["longitude"]})
          .toList()
          .cast<Map<String, double>>();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<void> launchDirectionsToAddress({
    required String address,
  }) async {
    return methodChannel.invokeMethod(
      'launchDirectionsToAddress',
      <String, Object>{
        'address': address,
      },
    );
  }
}
