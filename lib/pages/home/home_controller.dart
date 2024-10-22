import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final Dio _dio = Dio();
  MapController? mapController;
  LatLng currentLocation = const LatLng(10.762622, 106.660172);
  String currentLocationName = '';
  List<Marker> markers = [];
  var currentZoom = 10.0.obs;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    markers.add(
      Marker(
        point: currentLocation,
        child: const Icon(
          Icons.location_pin,
          color: Colors.red,
        ),
      ),
    );
    updateCurrentLocationName();
  }

  void updateCurrentLocationName() async {
    final String url =
        'https://nominatim.openstreetmap.org/reverse?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&format=json';
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      currentLocationName = response.data['display_name'];
      update();
    } else {
      throw Exception('Failed to load location name');
    }
  }

  void zoomIn() {
    currentZoom.value += 1;
    mapController?.move(markers.last.point, currentZoom.value);
  }

  void zoomOut() {
    if (currentZoom.value > 1) {
      currentZoom.value -= 1;
      mapController?.move(markers.last.point, currentZoom.value);
    }
  }

  void addMarker(LatLng position, String title) {
    markers.add(
      Marker(
        point: position,
        child: IconButton(
          icon: const Icon(
            Icons.location_pin,
            color: Colors.red,
          ),
          onPressed: () {
            _showDetailsPlace(title);
          },
        ),
      ),
    );

    update();
  }

  void moveToLocation(LatLng position) {
    currentLocation = position;
    mapController?.move(position, currentZoom.value);
    updateCurrentLocationName();
  }

  void clearMarkers() {
    markers.clear();
    update();
  }

  void _showDetailsPlace(String title) {
    Get.defaultDialog(
      title: 'Location details:',
      middleText: 'Name: $title',
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Close'),
      ),
    );
  }

  Future<void> searchPlace(String query) async {
    final String url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      List results = response.data;
      clearMarkers();
      for (var result in results) {
        double lat = double.parse(result['lat']);
        double lon = double.parse(result['lon']);
        addMarker(LatLng(lat, lon), result['display_name']);
        moveToLocation(LatLng(lat, lon));
      }
    } else {
      throw Exception('Failed to load place');
    }
  }
}
