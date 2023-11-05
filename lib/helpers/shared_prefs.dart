import 'package:b04f/models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPrefs {
  Future<void> storeValue(String newLocation, List<LatLng> allPoints, List<LatLng> selectedPoints, LatLng myPoints) async {
    var instance = await SharedPreferences.getInstance();
    var newLocationObj = History(
      UniqueKey().toString(),
      newLocation,
      DateTime.now().millisecondsSinceEpoch,
      allPoints,
      selectedPoints,
      myPoints
    );
    var oldHistory = await getHistory();
    oldHistory.add(newLocationObj);
    await instance.setStringList("history", oldHistory.toSet().toList().map((e) => e.toString()).toList());
  }

  static Future<List<History>> getHistory() async {
    var instance = await SharedPreferences.getInstance();
    var storedValues = instance.getStringList("history") ?? [];
    return storedValues.map((e) => History.fromString(e)).toList();
  }
}
