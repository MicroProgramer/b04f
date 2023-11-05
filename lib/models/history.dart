import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

///nullable, constructor, default value
class History {
  String id;
  String query;
  int timestamp;
  List<LatLng> allPoints;
  List<LatLng> selectedPoints;
  LatLng currentPoint;

  History(this.id, this.query, this.timestamp, this.allPoints, this.selectedPoints, this.currentPoint);

  ///Encoding Methods
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "query": query,
      "timestamp": timestamp,
      "allPoints": allPoints.map((e) => jsonEncode({"lat": e.latitude, "lng": e.longitude})).toList(),
      "selectedPoints": selectedPoints.map((e) => jsonEncode({"lat": e.latitude, "lng": e.longitude})).toList(),
      "currentPoint": jsonEncode({"lat": currentPoint.latitude, "lng": currentPoint.longitude})
    };
  }

  static LatLng fromLatLngMap(Map<String, dynamic> data) {
    return LatLng(data['lat'], data['lng']);
  }

  String toString() {
    return jsonEncode(toMap());
  }

  ///Decoding Methods
  factory History.fromMap(Map<String, dynamic> data) {
    return History(
      data['id'] as String,
      data['query'] as String,
      data['timestamp'] as int,
      (data['allPoints'] as List<dynamic>).map((e) => fromLatLngMap(jsonDecode(e.toString()) as Map<String, dynamic>)).toList(),
      (data['selectedPoints'] as List<dynamic>).map((e) => fromLatLngMap(jsonDecode(e.toString()) as Map<String, dynamic>)).toList(),
      fromLatLngMap(jsonDecode(data['currentPoint'] as String))
    );
  }

  factory History.fromString(String data) {
    return History.fromMap(jsonDecode(data) as Map<String, dynamic>);
  }
}
