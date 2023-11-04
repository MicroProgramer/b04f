import 'package:shared_preferences/shared_preferences.dart';

class MyPrefs {

  Future<void> storeValue(String newLocation) async {
    var instance = await SharedPreferences.getInstance();
    var oldHistory = instance.getStringList('history') ?? [];
    oldHistory.add(newLocation);
    await instance.setStringList("history", oldHistory.toSet().toList());
  }

  Future<List<String>> getHistory() async {
    var instance = await SharedPreferences.getInstance();
    var storedValues = instance.getStringList("history") ?? [];
    return storedValues;
  }

}