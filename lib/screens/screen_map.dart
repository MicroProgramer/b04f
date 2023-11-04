import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenMap extends StatelessWidget {
  List<LatLng> allPoints;
  String locationName;
  LatLng currentLocation;
  List<LatLng> selectedLocations;
  double distance;

  @override
  Widget build(BuildContext context) {
    print(allPoints);

    return Scaffold(
      appBar: AppBar(
        title: Text(locationName),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: currentLocation, zoom: 10),
              markers: [
                ...allPoints.map(
                  (e) {
                    var selected = selectedLocations.contains(e);

                    return Marker(
                        markerId: MarkerId("${e.latitude}"),
                        infoWindow: InfoWindow(title: "Lat: ${e.latitude}\nLng: ${e.longitude}", snippet: selected ? "Selected Location" : null),
                        position: e,
                        icon: BitmapDescriptor.defaultMarkerWithHue(selected ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed));
                  },
                ),
                Marker(
                    markerId: MarkerId("${currentLocation.latitude}"),
                    infoWindow: InfoWindow(title: "My location"),
                    position: currentLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen))
              ].toSet(),
            ),
          ),
          Text("Distance: ${distance}km")
        ],
      ),
    );
  }

  ScreenMap({
    required this.allPoints,
    required this.locationName,
    required this.currentLocation,
    required this.selectedLocations,
    required this.distance,
  });
}
