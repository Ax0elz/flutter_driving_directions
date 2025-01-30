import Flutter
import UIKit
import MapKit

public class SwiftFlutterDrivingDirectionsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_driving_directions", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterDrivingDirectionsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as! Dictionary<String, Any>
    let latitude = arguments["latitude"] as! Double
    let longitude = arguments["longitude"] as! Double
    let address = arguments["address"] as! String

    if call.method == "getDirectionsPolylines" {
      let args = call.arguments as! [String: Any]
      let fromLat = args["fromLat"] as! Double
      let fromLng = args["fromLng"] as! Double
      let toLat = args["toLat"] as! Double
      let toLng = args["toLng"] as! Double
      let sourcePlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: fromLat, longitude: fromLng))
      let destPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: toLat, longitude: toLng))
      let request = MKDirections.Request()
      request.source = MKMapItem(placemark: sourcePlacemark)
      request.destination = MKMapItem(placemark: destPlacemark)
      request.transportType = .automobile

      MKDirections(request: request).calculate { response, error in
        guard let route = response?.routes.first else {
          result(FlutterError(code: "ROUTE_ERROR", message: error?.localizedDescription, details: nil))
          return
        }
        let polyline = route.polyline
        var coordinates = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: polyline.pointCount)
        polyline.getCoordinates(&coordinates, range: NSRange(location: 0, length: polyline.pointCount))
        let coordsArray = coordinates.map { ["latitude": $0.latitude, "longitude": $0.longitude] }
        result(coordsArray)
      }
    }

    if call.method == "launchDirectionsToAddress" {
      let address = arguments["address"] as! String
      let geocoder = CLGeocoder()
      geocoder.geocodeAddressString(address) { placemarks, error in
        guard let placemark = placemarks?.first?.location else {
          result(FlutterError(code: "GEOCODE_ERROR", message: error?.localizedDescription, details: nil))
          return
        }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.coordinate))
        mapItem.name = address
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        result(nil)
      }
    }

    if #available(iOS 10, *) {
      let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let placemark = MKPlacemark(coordinate: coordinate)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = address
      mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
  }
}
