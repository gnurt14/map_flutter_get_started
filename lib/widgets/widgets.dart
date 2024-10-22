import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

TextStyle getDefaultTextStyle() {
  return const TextStyle(
    fontSize: 12,
    backgroundColor: Colors.black,
    color: Colors.white,
  );
}

Container buildTextWidget(String word) {
  return Container(
      alignment: Alignment.center,
      child: Text(word,
          textAlign: TextAlign.center, style: getDefaultTextStyle()));
}

Marker buildMarker(LatLng coordinates, String word) {
  return Marker(
    point: coordinates,
    width: 150,
    height: 20,
    child: buildTextWidget(word),
  );
}
