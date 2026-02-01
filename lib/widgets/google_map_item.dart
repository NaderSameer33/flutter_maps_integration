import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps_intgration/models/map_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

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
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    createPlyLine();
    createMarker();
    createMapStyle();
    cameraPosition = CameraPosition(
      zoom: 1,
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

  Future<BitmapDescriptor> createCutomMarker() async {
    var customMarker = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(20, 20)),
      'assets/images/marker2.png',
    );
    return customMarker;
  }

  void createMarker() async {
    var icon = await createCutomMarker();
    var myMarker = list
        .map(
          (e) => Marker(
            icon: icon,
            infoWindow: InfoWindow(
              title: e.name,
            ),
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

  void createPlyLine() {
    var polyLineData = polyLineList
        .map(
          (model) => Polyline(
            geodesic: true,
            zIndex: 10,
            startCap: Cap.roundCap,
            color: Colors.red,
            width: 5,
            polylineId: PolylineId(model.id),
            points: model.lating,
          ),
        )
        .toSet();
    polylines.addAll(polyLineData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            polylines: polylines,
            zoomControlsEnabled: false,
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

class PolylineModel {
  final String id;
  final List<LatLng> lating;
  PolylineModel(this.id, this.lating);
}

List<PolylineModel> polyLineList = [
  PolylineModel('neshar&nabaruh', [
    LatLng(31.12713961543846, 31.291574473598246),
    LatLng(31.097206838135566, 31.30576955578635),
  ]),
  PolylineModel('nabaruh&byla', [
    LatLng(31.097206838135566, 31.30576955578635),
    LatLng(31.170558599682327, 31.222880131522405),
  ]),
  PolylineModel('aldeen & abdeljany', [
    LatLng(31.104233589178055, 31.269490481110104),
    LatLng(31.121869722880067, 31.317384002859825),
  ]),
  PolylineModel('africa & turkia', [
    LatLng(-32.43403248415015, 22.651472347820484),
    LatLng(70.81735656288016, 127.2481522340003),
  ]),
];
