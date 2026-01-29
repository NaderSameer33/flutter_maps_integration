import 'package:flutter/material.dart';
import 'package:flutter_google_maps_intgration/models/map_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapItem extends StatefulWidget {
  const GoogleMapItem({super.key});

  @override
  State<GoogleMapItem> createState() => _GoogleMapItemState();
}

class _GoogleMapItemState extends State<GoogleMapItem> {
  late CameraPosition cameraPosition;
  late GoogleMapController _controller;

  String mapStyle = '';
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    createMarker();
    createMapStyle();
    cameraPosition = CameraPosition(
      zoom: 13,
      target: LatLng(
        31.12397562358649,
        31.28898459645746,
      ),
    );
  }

  Future<void> createMapStyle() async {
    mapStyle = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/lotties/style.json');
    setState(() {});
  }

  void createMarker() {
    var myMarker = list
        .map(
          (e) => Marker(
            markerId: MarkerId(e.id),
            position: e.latLng,
          ),
        )
        .toSet();
    markers.addAll(myMarker);
  }

  Future<void> moveToNabrou() async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 16,
          target: LatLng(31.164551278045366, 31.071437043464),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            style: mapStyle,
            onMapCreated: (controller) {
              _controller = controller;
            },
            initialCameraPosition: cameraPosition,
          ),
          Positioned(
            bottom: 12,
            right: 12,
            left: 12,
            child: ElevatedButton(
              onPressed: moveToNabrou,
              child: Text('Change Location'),
            ),
          ),
        ],
      ),
    );
  }
}
