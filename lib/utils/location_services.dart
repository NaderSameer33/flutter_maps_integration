import 'package:location/location.dart';

class LocationServices {
  Location location = Location();

  Future<bool> checkLocationServicesAndRequest() async {
    bool isEnableLocation = await location.serviceEnabled();
    if (!isEnableLocation) {
      bool isEnableLocation = await location.requestService();
      if (!isEnableLocation) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkLocationPremetions() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      var permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.deniedForever) {
        return false;
      }
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void getRealTimeLocationServiec(Function(LocationData)? onData) {
    location.changeSettings(distanceFilter: 20, interval: 10);
    location.onLocationChanged.listen((onData));
  }
}
