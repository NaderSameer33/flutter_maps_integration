import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterGoogleMapsIntegration());
}

class FlutterGoogleMapsIntegration extends StatelessWidget {
  const FlutterGoogleMapsIntegration({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
   
      home: Scaffold(body: Center (child: Text('Flutter google maps Integration'),),)
    );
  }
}
