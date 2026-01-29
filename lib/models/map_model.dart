import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapModel {
  final String id;
  final String name;
  final LatLng latLng;
  MapModel({required this.id, required this.latLng, required this.name});
}

List<MapModel> list = [
  MapModel(
    id: '1',
    latLng: LatLng(31.12713961543846, 31.291574473598246),
    name: 'nesha',
  ),
  MapModel(
    id: '2',
    latLng: LatLng(31.097206838135566, 31.30576955578635),
    name: 'nabaruh',
  ),
  MapModel(
    id: '3',
    latLng: LatLng(31.170558599682327, 31.222880131522405),
    name: 'beyala',
  ),
];
