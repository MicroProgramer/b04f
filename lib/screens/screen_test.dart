import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenTest extends StatelessWidget {
  RxInt x = RxInt(0);
  int y = 10;

  @override
  Widget build(BuildContext context) {

    print("Widgets rebuilt");

    return Scaffold(
      appBar: AppBar(
        title: Text("Test Screen"),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              return Text(
                "${x.value}",
                style: TextStyle(fontSize: 20),
              );
            }),
            Text("${x.value}")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          x.value = x.value + 1;
        },
        child: Text("Add"),
      ),
    );
  }
}
