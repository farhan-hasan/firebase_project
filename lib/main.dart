import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LocationApp());
}

class LocationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  LatLng? _center = LatLng(24.049795138879755, 90.38305285817978);
  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(24.049795138879755, 90.38305285817978),
  );
  List<LatLng> polyLinePoints = [];

  void getCurrentLocation() async {
    LocationPermission requestStatus = await Geolocator.requestPermission();
    if (requestStatus == LocationPermission.whileInUse ||
        requestStatus == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(
              LatLng(position.latitude, position.longitude), 19.0),
        );
        polyLinePoints.add(LatLng(position.latitude, position.longitude));
        _center = LatLng(position.latitude, position.longitude);
      });
    } else {
      print("permission denied");
    }
  }

  void _listenLocation() {
    Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(
              LatLng(position.latitude, position.longitude), 19.0),
        );
        polyLinePoints.add(LatLng(position.latitude, position.longitude));
        _center = LatLng(position.latitude, position.longitude);
        print(polyLinePoints);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-Time Location Tracker"),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _listenLocation();
        },
        markers: {
          Marker(
            markerId: const MarkerId("real-time-location"),
            position: _center!,
            infoWindow: InfoWindow(
                title: "My Current Location",
                snippet: "${_center!.latitude} , ${_center!.longitude}"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                (BitmapDescriptor.hueRed)),
            draggable: true
          ),
        },
        polylines: {
      Polyline(
            polylineId: PolylineId("live-polyline"),
            color: Colors.blue,
            width: 5,
            points: polyLinePoints
          )
        },
      ),
    );
  }
}
