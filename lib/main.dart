import 'package:flutter/material.dart';
import 'package:flutter_google_maps_intgration/widgets/google_map_item.dart';

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
        body:GoogleMapItem()

      ),
    );
  }
}
