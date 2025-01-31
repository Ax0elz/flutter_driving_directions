import 'package:flutter_driving_directions/flutter_driving_directions.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_driving_directions_method_channel.dart';

abstract class FlutterDrivingDirectionsPlatform extends PlatformInterface {
  /// Constructs a FlutterDrivingDirectionsPlatform.
  FlutterDrivingDirectionsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDrivingDirectionsPlatform _instance =
      MethodChannelFlutterDrivingDirections();

  /// The default instance of [FlutterDrivingDirectionsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDrivingDirections].
  static FlutterDrivingDirectionsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterDrivingDirectionsPlatform] when
  /// they register themselves.
  static set instance(FlutterDrivingDirectionsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> launchDirections({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    throw UnimplementedError('launchDirections() has not been implemented.');
  }

  Future<void> launchDirectionsToAddress({
    required String address,
  }) {
    throw UnimplementedError(
        'launchDirectionsToAddress() has not been implemented.');
  }

  Future<List<Map<String, double>>> getDirectionsPolylines({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    TransportTypeEnum? transportType,
  }) {
    throw UnimplementedError(
        'getDirectionsPolylines() has not been implemented.');
  }
}
