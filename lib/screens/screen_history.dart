import 'package:b04f/helpers/shared_prefs.dart';
import 'package:flutter/material.dart';
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
      body: FutureBuilder<List<String>>(
        future: MyPrefs().getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var history = (snapshot.data ?? []).reversed.toList();

          return history.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(history[index]),
                      leading: Icon(Icons.history),
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
