import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  final double blindPersonLatitude;
  final double blindPersonLongitude;

  MapScreen({
    required this.blindPersonLatitude,
    required this.blindPersonLongitude,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double? currentLatitude;
  double? currentLongitude;
  bool isButtonPressed = false;
  late String requestIdentifier;

  @override
  void initState() {
    super.initState();
    requestIdentifier = DateTime.now().toString();
    _getCurrentLocation();
    _loadButtonState();
  }

  Future<void> _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
    });
  }

  Future<void> _loadButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isButtonPressed = prefs.getBool(requestIdentifier) ?? false;
    });
  }

  Future<void> _saveButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(requestIdentifier, isButtonPressed);
  }

  double calculateDistance() {
    if (currentLatitude != null && currentLongitude != null) {
      final userLocation = latLng.LatLng(currentLatitude!, currentLongitude!);
      final blindPersonLocation =
      latLng.LatLng(widget.blindPersonLatitude, widget.blindPersonLongitude);
      return latLng.Distance().as(
          latLng.LengthUnit.Kilometer, userLocation, blindPersonLocation);
    }
    return 0.0;
  }

  String calculateETA() {
    final distance = calculateDistance();
    final averageSpeed = 50; // Assume average speed in km/h
    final estimatedTimeInHours = distance / averageSpeed;
    final estimatedTimeInMinutes = (estimatedTimeInHours * 60).round();
    return '$estimatedTimeInMinutes minutes';
  }

  void confirmButtonPressed() {
    final distance = calculateDistance();
    final eta = calculateETA();
    Navigator.pop(context, {'distance': distance, 'eta': eta});
    setState(() {
      isButtonPressed = true;
    });
    _saveButtonState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLatitude == null || currentLongitude == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Map Screen'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(currentLatitude!, currentLongitude!),
          zoom: 10.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: latLng.LatLng(currentLatitude!, currentLongitude!),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                ),
              ),
              Marker(
                width: 40.0,
                height: 40.0,
                point: latLng.LatLng(
                    widget.blindPersonLatitude, widget.blindPersonLongitude),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Distance: ${calculateDistance().toStringAsFixed(2)} km',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Estimated Time of Arrival: ${calculateETA()}',
              style: TextStyle(fontSize: 18.0),
            ),
            Visibility(
              visible: !isButtonPressed,
              child: ElevatedButton(
                onPressed: confirmButtonPressed,
                child: Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
