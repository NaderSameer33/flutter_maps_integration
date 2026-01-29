import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const FlutterGoogleMapsIntegration());
}

class FlutterGoogleMapsIntegration extends StatefulWidget {
  const FlutterGoogleMapsIntegration({super.key});

  @override
  State<FlutterGoogleMapsIntegration> createState() =>
      _FlutterGoogleMapsIntegrationState();
}

class _FlutterGoogleMapsIntegrationState
    extends State<FlutterGoogleMapsIntegration> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: (controller) {},
          initialCameraPosition: CameraPosition(
            zoom: 16,
            target: LatLng(
              31.12397562358649,
              31.28898459645746,
            ),
          ),
        ),
      ),
    );
  }
}
