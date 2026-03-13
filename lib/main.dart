import 'package:flutter/material.dart';
import 'package:flutter_google_maps_intgration/widgets/root_track_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  runApp(const FlutterGoogleMapsIntegration());
}

class FlutterGoogleMapsIntegration extends StatelessWidget {
  const FlutterGoogleMapsIntegration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FlutterGoogleTracking(),

        //GoogleMapItem()
      ),
    );
  }
}
