import 'package:b04f/screens/screen_map.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  TextEditingController addressController = TextEditingController();
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Future Builder",
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Enter address"),
              controller: addressController,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text("Get Lat Lng")),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Location>>(
              future: locationFromAddress(addressController.text),
              builder: (context, snapshot) {
                //
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading...");
                }

                var data = snapshot.data ?? [];

                return data.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            var item = data[index];
                            return RadioListTile(
                              title: Text("Lat: ${item.latitude}, Lng: ${item.longitude}"), value: LatLng(item.latitude, item.longitude),
                              groupValue: selectedLocation,
                              onChanged: (LatLng? value) {
                                setState(() {
                                  selectedLocation = value;
                                });
                              },
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (_) => ScreenMap(
                              //         lat: item.latitude,
                              //         lng: item.longitude,
                              //         locationName: addressController.text,
                              //       ),
                              //     ),
                              //   );
                              // },
                            );
                          },
                          itemCount: data.length,
                        ),
                      )
                    : Text("No locations");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedLocation == null) {
            showSnackbar("No location selected", context);
            return;
          }

          var permissionStatus = await Permission.location.request();
          if (permissionStatus.isGranted) {
            try {
              var currentLocation = await Geolocator.getCurrentPosition();

              var distance = Geolocator.distanceBetween(
                currentLocation.latitude,
                currentLocation.longitude,
                selectedLocation!.latitude,
                selectedLocation!.longitude,
              );
              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScreenMap(
                        lat: currentLocation.latitude,
                        lng: currentLocation.longitude,
                        locationName: addressController.text,
                      ),
                    ),
                  );


              showSnackbar("Distance: ${(distance / 1000).toStringAsFixed(2)} km", context);
            } catch (e) {
              showSnackbar(e.toString(), context);
            }
          } else {
            showSnackbar("Allow location first", context);
          }

          // Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
        },
        label: Text("Calculate distance"),
      ),
    );
  }

  void showSnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
