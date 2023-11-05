import 'package:b04f/helpers/shared_prefs.dart';
import 'package:b04f/helpers/utils.dart';
import 'package:b04f/screens/screen_history.dart';
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
  List<LatLng> selectedLocations = [];
  List<Location> data = [];
  bool loadingCurrentPos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Future Builder",
        ),
        actions: [
          IconButton(
              onPressed: () {
                openScreen(context: context, screen: ScreenHistory());
              },
              icon: Icon(Icons.history))
        ],
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

                data = snapshot.data ?? [];

                return data.isNotEmpty
                    ? Expanded(
                        child: StatefulBuilder(builder: (context, refreshBuilder) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              var item = data[index];
                              var point = LatLng(item.latitude, item.longitude);

                              return CheckboxListTile(
                                title: Text("Lat: ${item.latitude}, Lng: ${item.longitude}"), value: selectedLocations.contains(point),
                                onChanged: (selected) {
                                  if (selected ?? false) {
                                    if (!selectedLocations.contains(point)) {
                                      selectedLocations.add(point);
                                    }
                                  } else {
                                    selectedLocations.remove(point);
                                  }
                                  refreshBuilder(() {});
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
                          );
                        }),
                      )
                    : Text("No locations");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: StatefulBuilder(builder: (context, refreshFloating) {
        return FloatingActionButton.extended(
          onPressed: loadingCurrentPos
              ? null
              : () async {
                  if (selectedLocations.isEmpty) {
                    showSnackbar("No location selected", context);
                    return;
                  }

                  refreshFloating(() {
                    loadingCurrentPos = true;
                  });

                  var permissionStatus = await Permission.location.request();
                  if (permissionStatus.isGranted) {
                    try {
                      var currentLocation = await Geolocator.getCurrentPosition();

                      var distance = Geolocator.distanceBetween(
                        currentLocation.latitude,
                        currentLocation.longitude,
                        selectedLocations.first.latitude,
                        selectedLocations.first.longitude,
                      );

                      try {
                        MyPrefs().storeValue(
                            addressController.text,
                            data.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                            selectedLocations,
                            LatLng(currentLocation.latitude, currentLocation.longitude)
                        );
                      } catch (e){
                        print("Exception: $e");
                      }

                      openScreen(
                          context: context,
                          screen: ScreenMap(
                            locationName: addressController.text,
                            allPoints: data.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                            currentLocation: LatLng(currentLocation.latitude, currentLocation.longitude),
                            selectedLocations: selectedLocations,
                            distance: distance,
                          ));

                      showSnackbar("Distance: ${(distance / 1000).toStringAsFixed(2)} km", context);
                    } catch (e) {
                      showSnackbar(e.toString(), context);
                    }
                  } else {
                    showSnackbar("Allow location first", context);
                  }

                  refreshFloating(() {
                    loadingCurrentPos = false;
                  });

                  // Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
                },
          label: loadingCurrentPos
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
              : Text("Calculate distance"),
        );
      }),
    );
  }

  void showSnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

// void printStoredValue() async {
//   var storedValue = await MyPrefs().getHistory();
//   print("StoredValue: $storedValue");
// }
}
