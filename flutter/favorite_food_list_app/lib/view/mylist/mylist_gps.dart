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

class MylistGPS extends StatefulWidget {
  const MylistGPS({super.key});

  @override
  State<MylistGPS> createState() => _MylistGPSState();
}

class _MylistGPSState extends State<MylistGPS> {

  var values = Get.arguments ?? '';

  late Position currentPosition;
  late String name;
  late double lat;
  late double lng;
  late MapController mapController; // flutter_map

  @override
  void initState() {
    super.initState();
    name = values[0];
    lat = double.parse(values[1]);
    lng = double.parse(values[2]);
    mapController = MapController();  
  }

  // ---- Functions -----

  // ============================
  // --------- 화면 구상 ---------
  // ============================
  Widget flutterMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(lat, lng),
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
              point: latlng.LatLng(lat, lng), 
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