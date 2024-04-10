import 'package:favorite_food_list_app/vm/vm_mylist_getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

/*
    Date: 2024-04-07
    Author : Woody Jo
    Description : Favorite Food Mylist View GPS map Page, get lat,lun
                  datas and then show GPS map 
*/

class MylistGPS extends StatelessWidget {
  MylistGPS({super.key});

  // --- Property ---
  final controller = Get.put(VMMylistGetX());
  final MapController mapController = MapController(); // flutter_map
  Position? currentPosition;
  String name = '';
  var values = Get.arguments ?? '';



  setArgu(){
    name = values[0];
    controller.lat = double.parse(values[1]);
    controller.lng = double.parse(values[2]);
  }

  

  // --- Function ---
  Widget flutterMap() {
    setArgu();
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(controller.lat, controller.lng),
        initialZoom: 17.0
      ), 
      children: [
        TileLayer( // 화면 그림 그리는 친구
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer( // 위치 표시
          markers: [
            Marker(
              width: 80,
              height: 80,
              point: latlng.LatLng(controller.lat, controller.lng), 
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  const Icon(
                    Icons.pin_drop,
                    size: 50,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ]
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name 위치'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: flutterMap(),
    );
  }
}