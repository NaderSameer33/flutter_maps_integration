import 'package:location/location.dart';

class LocationServices {
  Location location = Location();

  Future<void> checkLocationServicesAndRequest() async {
    bool isEnableLocation = await location.serviceEnabled();
    if (!isEnableLocation) {
      bool isEnableLocation = await location.requestService();
      if (!isEnableLocation) {
        throw LocationServiceSException();
      }
    }
  }

  Future<void> checkLocationPremetions() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      var permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.deniedForever) {
        throw LocationServicesPermisionException();
      }
      if (permissionStatus != PermissionStatus.granted) {
        throw LocationServicesPermisionException();
      }
    }
  }

  void getRealTimeLocationServiec(Function(LocationData)? onData) async {
    await checkLocationServicesAndRequest();
    await checkLocationPremetions();

    location.onLocationChanged.listen((onData));
  }

  Future<LocationData> getLocation() async {
     await checkLocationServicesAndRequest();
    await checkLocationPremetions();
    return await location.getLocation();
  }
}

class LocationServiceSException implements Exception {}

class LocationServicesPermisionException implements Exception {}
