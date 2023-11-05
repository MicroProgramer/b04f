import 'package:b04f/helpers/shared_prefs.dart';
import 'package:b04f/helpers/utils.dart';
import 'package:b04f/models/history.dart';
import 'package:b04f/screens/screen_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenHistory extends StatefulWidget {
  const ScreenHistory({Key? key}) : super(key: key);

  @override
  State<ScreenHistory> createState() => _ScreenHistoryState();
}

class _ScreenHistoryState extends State<ScreenHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Clear history"),
                    content: Text("Are you sure to clear the history"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Dismiss")),
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await (await SharedPreferences.getInstance()).clear();
                            setState(() {});
                          },
                          child: Text("Clear")),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.clear)),
        ],
      ),
      body: FutureBuilder<List<History>>(
        future: MyPrefs.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var history = (snapshot.data ?? []).reversed.toList();

          return history.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (_, index) {
                    var item = history[index];

                    return ListTile(
                      title: Text(item.query),
                      subtitle: Text(item.id),
                      leading: Icon(Icons.history),
                      trailing: Text(DateFormat("EEE dd MMM HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(item.timestamp))),
                      onTap: () {
                        openScreen(
                          context: context,
                          screen: ScreenMap(
                              allPoints: item.allPoints,
                              locationName: "from History",
                              currentLocation: item.currentPoint,
                              selectedLocations: item.selectedPoints,
                              distance: Geolocator.distanceBetween(item.selectedPoints.first.latitude, item.selectedPoints.first.longitude,
                                  item.currentPoint.latitude, item.currentPoint.longitude)),
                        );
                      },
                    );
                  },
                  itemCount: history.length,
                )
              : Center(
                  child: Text("No history"),
                );
        },
      ),
    );
  }
}
