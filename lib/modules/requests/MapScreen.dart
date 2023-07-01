import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latLng;

class MapScreen extends StatefulWidget {
  final double blindPersonLatitude;
  final double blindPersonLongitude;

  MapScreen({required this.blindPersonLatitude, required this.blindPersonLongitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double? currentLatitude;
  double? currentLongitude;
  double distance = 0.0;
  String estimatedTimeOfArrival = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
      _calculateDistance();
      _calculateETA();
    });
  }

  void _calculateDistance() {
    if (currentLatitude != null && currentLongitude != null) {
      latLng.LatLng userLocation = latLng.LatLng(currentLatitude!, currentLongitude!);
      latLng.LatLng blindPersonLocation = latLng.LatLng(widget.blindPersonLatitude, widget.blindPersonLongitude);
      distance = latLng.Distance().as(latLng.LengthUnit.Kilometer, userLocation, blindPersonLocation);
    }
  }

  void _calculateETA() {
    // Calculate the estimated time of arrival based on distance and average travel speed
    double averageSpeed = 50; // Assume average speed in km/h
    double estimatedTimeInHours = distance / averageSpeed;
    int estimatedTimeInMinutes = (estimatedTimeInHours * 60).round();
    estimatedTimeOfArrival = '$estimatedTimeInMinutes minutes';
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
                point: latLng.LatLng(widget.blindPersonLatitude, widget.blindPersonLongitude),
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
              'Distance: ${distance.toStringAsFixed(2)} km',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Estimated Time of Arrival: $estimatedTimeOfArrival',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
