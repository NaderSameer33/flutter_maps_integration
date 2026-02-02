import 'package:flutter/material.dart';
import 'package:flutter_google_maps_intgration/widgets/root_track_item.dart';

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
        body: RootTrackItem(),

        //GoogleMapItem()
      ),
    );
  }
}

// location services request for enable services 
// request premstion from a user 
//  get location 
// display  it
