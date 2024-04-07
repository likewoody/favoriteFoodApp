import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

/*
    Date: 2024-04-07
    Author : Woody Jo
    Description : Favorite Food Worldlist View GPS map Page, get lat,lun
                  datas and then show GPS map 
*/

class WorldListGPS extends StatefulWidget {
  const WorldListGPS({super.key});

  @override
  State<WorldListGPS> createState() => _WorldListGPSState();
}

class _WorldListGPSState extends State<WorldListGPS> {

  // Property
  var values = Get.arguments ?? '';
  late double lat;
  late double lng;
  late Position currentPosition;
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    lat = double.parse(values[1]);
    lng = double.parse(values[2]);
  }

  // --- Function ----
  Widget flutterMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(lat, lng),
        initialZoom: 17.0,
      ), 
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80,
              height: 80,
              point: latlng.LatLng(lat, lng), 
              child: Column(
                children: [
                  Text(
                    values[1],
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
          ],
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${values[0]}의 위치"),
      ),
      body: flutterMap(),
    );
  }
}