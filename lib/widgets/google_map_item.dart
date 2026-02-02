import 'package:flutter/material.dart';
import 'package:flutter_google_maps_intgration/models/map_model.dart';
import 'package:flutter_google_maps_intgration/utils/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapItem extends StatefulWidget {
  const GoogleMapItem({super.key});

  @override
  State<GoogleMapItem> createState() => _GoogleMapItemState();
}

class _GoogleMapItemState extends State<GoogleMapItem> {
  late CameraPosition cameraPosition;
  GoogleMapController? _controller;
  late LocationServices _locationServices;

  String mapStyle = '';
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  bool isFirstCall = true;

  @override
  void initState() {
    super.initState();
    _locationServices = LocationServices();
    createPlyLine();
    createMarker();
    createCircle();
    createMapStyle();
    createPolygon();
    upDataMyLocation();
    cameraPosition = CameraPosition(
      zoom: 1,
      target: LatLng(31.105580602929177, 30.943923665823245),
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
    await _controller!.animateCamera(
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
            circles: circles,
            polygons: polygons,
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

  void createPolygon() {
    Polygon polygon = Polygon(
      holes: [
        [
          LatLng(31.11199007905391, 31.282154831111928),
          LatLng(31.10237207173203, 31.286728332670183),
        ],
      ],
      fillColor: Colors.black.withValues(alpha: .6),
      polygonId: PolygonId('nesha&nabarua&dirin'),
      points: [
        LatLng(31.1268146302939, 31.295022019826124),
        LatLng(31.09624484222557, 31.299485215401365),
        LatLng(31.097420785306483, 31.26515294174565),
      ],
    );
    polygons.add(polygon);
  }

  void createCircle() {
    Color color = Colors.red.withValues(alpha: .7);
    Circle circle = Circle(
      strokeColor: color,
      radius: 1000,
      fillColor: color,

      circleId: CircleId('naesha'),
      center: LatLng(31.105580602929177, 30.943923665823245),
    );
    circles.add(circle);
  }

  void setLocationMarker(LocationData locationData) {
    var marker = Marker(
      markerId: MarkerId('currentPostion'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
    );
    markers.add(marker);
    setState(
      () {},
    ); // todo to updata a ui for a marker  animation camera not allowed to updata a ui
  }

  Future<void> upDataMyLocation() async {
    await _locationServices.checkLocationServicesAndRequest();
    bool isPermision = await _locationServices.checkLocationPremetions();
    if (isPermision) {
      _locationServices.getRealTimeLocationServiec((locationData) {
        setLocationMarker(locationData);

        upDataLocationStream(locationData);
      });
    }
  }

  void upDataLocationStream(LocationData locationData) {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(locationData.latitude!, locationData.longitude!),
      zoom: 17,
    );
    if (isFirstCall) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      isFirstCall = false;
    } else {
      _controller?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
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
