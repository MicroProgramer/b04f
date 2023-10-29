import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenMap extends StatelessWidget {
  double lat, lng;
  String locationName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationName),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 10),
              markers: {
                Marker(
                  markerId: MarkerId(locationName),
                  position: LatLng(lat, lng),
                  infoWindow: InfoWindow(
                    title: locationName,
                  )
                )
              },
            ),
          ),
          Text("Distance: 1000km")
        ],
      ),
    );
  }

  ScreenMap({
    required this.lat,
    required this.lng,
    required this.locationName,
  });
}
