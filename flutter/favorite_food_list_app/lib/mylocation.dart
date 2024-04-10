import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlng;

class Mylocation extends StatefulWidget {
  const Mylocation({super.key});

  @override
  State<Mylocation> createState() => _MylocationState();
}

class _MylocationState extends State<Mylocation> {

  late Position currentPosition;
  late MapController mapController;
  late bool canRun;
  late double lat;
  late double lng;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    canRun = false;
    checkLocationPermission(); 
  }

  checkLocationPermission() async{
    // 거절
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 영원히 거절
    if(permission == LocationPermission.deniedForever) {
      return; // 안쓴다.
    }

    // 사용 할 때만 or 계속
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      getCurrentLocation();
    }
  }

  getCurrentLocation() async{
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true).then((position) => {
        currentPosition = position,
        canRun = true,
        lat = currentPosition.latitude,
        lng = currentPosition.longitude,
        setState(() {}),
      });
  }

  Widget flutterMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(lat, lng),
        initialZoom: 17.0
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
              point: latlng.LatLng(lat,lng), 
              child: const Icon(
                Icons.pin_drop,
                size: 50,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('나의 현재 위치'),
      ),
      body: canRun
      ? flutterMap()
      : const Center(child: CircularProgressIndicator(),),
    );
  }
}