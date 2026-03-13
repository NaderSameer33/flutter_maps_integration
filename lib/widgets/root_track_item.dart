import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_intgration/models/auto_complete_mode.dart';
import 'package:flutter_google_maps_intgration/models/route_model.dart';
import 'package:flutter_google_maps_intgration/utils/location_services.dart';
import 'package:flutter_google_maps_intgration/widgets/custom_text_fild.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlutterGoogleTracking extends StatefulWidget {
  const FlutterGoogleTracking({super.key});

  @override
  State<FlutterGoogleTracking> createState() => _FlutterGoogleTrackingState();
}

class _FlutterGoogleTrackingState extends State<FlutterGoogleTracking> {
  final mapController = Completer<GoogleMapController>();
  late LocationServices locationServices;
  Set<Marker> marker = {};
  final dio = Dio();
  List<AutoCompleteModel> list = [];
  List<RoutModel> routes = [];
  List<LatLng> routsPolyLine = [];
  final controller = TextEditingController();
  late double currentLat, currentLong;
  double myLat = 0;
  double myLong = 0;
  Timer? debounce;

  Future<void> getCountrys({required String cityName}) async {
    try {
      final response = await dio.get(
        'https://api.locationiq.com/v1/autocomplete',
        queryParameters: {
          'key': 'pk.3184c546cea0f43e3d2c83e0a3160819',
          'q': cityName,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        list = AutoCompleteData.fromList(response.data).list;
        print('this list is $list');
      }
    } on DioException catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  Future<void> draweRoute({
    required double locationlong,
    required double locatoionLat,
    required double searchLong,
    required double searchLat,
  }) async {
    try {
      final reponse = await dio.get(
        'https://us1.locationiq.com/v1/directions/driving/$locationlong,$locatoionLat;$searchLong,$searchLat',
        queryParameters: {
          'key': 'pk.3184c546cea0f43e3d2c83e0a3160819',
          'geometries': 'geojson',
          'overview': 'full',
          'steps': 'true',
        },
      );
      if (reponse.statusCode == 200 || reponse.statusCode == 201) {
        routes = RouteData.fromJson(reponse.data).route;
        final cord = routes[0].routGemotry.cordnateRouting;
        routsPolyLine = cord.map((item) => LatLng(item[0], item[1])).toList();
        setState(() {});
      }
    } on DioException catch (e) {
      print(e.toString());
    }
  }

  Future<void> getCurrentLocation() async {
    locationServices.getRealTimeLocationServiec((location) {
      myLat = location.latitude ?? 0;
      myLong = location.longitude ?? 0;
      setState(() {});
    });

    await moveToCurrentLocation();
  }

  Future<void> moveToCurrentLocation() async {
    GoogleMapController controller = await mapController.future;
    CameraPosition cameraPosition = CameraPosition(
      zoom: 16,
      target: LatLng(myLat, myLong),
    );
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
    tagMarkerLocation();
  }

  void tagMarkerLocation() {
    marker.add(
      Marker(
        markerId: MarkerId('value'),
        position: LatLng(myLat, myLong),
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    locationServices = LocationServices();

    getCurrentLocation();
    getPlacesLocation();
  }

  Future<void> getPlacesLocation() async {
    debounce = Timer(Duration(microseconds: 500), () {
      controller.addListener(() async {
        if (debounce?.isActive ?? false) {
          debounce?.cancel();
        }
        if (controller.text.isNotEmpty) {
          await getCountrys(cityName: controller.text);

          setState(() {});
        } else {
          list.clear();
          setState(() {});
        }
      });
    });
  }

  Future<void> moveToCurrentCityLocation(AutoCompleteModel model) async {
    currentLat = double.parse(model.lat);
    currentLong = double.parse(model.long);
    final controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(currentLat, currentLong), zoom: 16),
      ),
    );
  }

  Future<void> getRoute(AutoCompleteModel placeDetails) async {
    await draweRoute(
      locationlong: myLong,
      locatoionLat: myLat,
      searchLong: currentLong,
      searchLat: currentLat,
    );
    await viewLatBounds();
  }

  Future<void> viewLatBounds() async {
    final controller = await mapController.future;
    var southwestlat = routsPolyLine.first.latitude;
    var southwestLong = routsPolyLine.first.longitude;
    var northeastlat = routsPolyLine.first.latitude;
    var northeastlong = routsPolyLine.first.longitude;

    for (var point in routsPolyLine) {
      southwestlat = min(southwestlat, point.latitude);
      southwestLong = min(southwestLong, point.longitude);
      northeastlat = max(northeastlat, point.latitude);
      northeastlong = max(northeastlong, point.longitude);
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(southwestlat, southwestLong),
      northeast: LatLng(northeastlat, northeastlong),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 32));
  }

  Future<void> moveToLocaionAfterRoute() async {
    final contller = await mapController.future;
    CameraPosition cameraPosition = CameraPosition(
      zoom: 16,
      target: LatLng(myLat, myLong),
    );
    contller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GoogleMap(
            polylines: {
              Polyline(
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                polylineId: PolylineId(DateTime.now().toString()),
                points: routsPolyLine,
              ),
            },
            markers: marker,
            onMapCreated: (contrller) {
              mapController.complete(contrller);
            },

            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
            ),
          ),
          Positioned(
            top: 50,
            right: 0,
            left: 0,

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomTextFild(controller: controller),
                ),
                SizedBox(
                  height: 10,
                ),
                PlacesListView(
                  list: list,
                  moveToCurrentCityLocation: moveToCurrentCityLocation,
                  ontap: (placeDetails) async {
                    list.clear();
                    controller.clear();
                    setState(() {});

                    await getRoute(placeDetails);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 10,
            child: ElevatedButton(
              onPressed: moveToLocaionAfterRoute,
              child: Text(
                'Move to loation to Track it',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlacesListView extends StatefulWidget {
  const PlacesListView({
    super.key,
    required this.list,
    required this.moveToCurrentCityLocation,
    required this.ontap,
  });

  final List<AutoCompleteModel> list;
  final Function(AutoCompleteModel) moveToCurrentCityLocation;
  final Function(AutoCompleteModel placeDetails) ontap;

  @override
  State<PlacesListView> createState() => _PlacesListViewState();
}

class _PlacesListViewState extends State<PlacesListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(
          onTap: () async {
            await widget.moveToCurrentCityLocation(widget.list[index]);
            widget.ontap(widget.list[index]);
          },
          leading: Icon(FontAwesomeIcons.mapPin),
          title: Text(widget.list[index].displayName),
          trailing: Icon(Icons.arrow_forward),
        ),
        separatorBuilder: (context, index) => Divider(
          height: 0,
        ),
        itemCount: widget.list.length,
      ),
    );
  }
}
