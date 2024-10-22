import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place...',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    await controller.searchPlace(searchController.text);
                  },
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: controller.currentLocation,
                  initialZoom: 8.0,
                  onTap: (tapPosition, point) {
                    controller.addMarker(point, 'Tapped location');
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: controller.markers,
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: () {
                        controller.moveToLocation(controller.currentLocation);
                        controller.addMarker(controller.currentLocation,
                            controller.currentLocationName);
                      },
                      child: const Icon(
                        Icons.navigation,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 80,
                right: 20,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.zoomIn();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.lightBlue[100],
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.zoomOut();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.lightBlue[100],
                        ),
                        child: const Icon(Icons.horizontal_rule),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
