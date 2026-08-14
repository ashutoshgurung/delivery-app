import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationViewModel extends ChangeNotifier {
  LatLng userLocation = const LatLng(27.7172, 85.3240);
  LatLng riderLocation = const LatLng(27.7200, 85.3300);

  double progress = 0.1;

  Timer? _timer;

  Future<void> initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition();

    userLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();

    startRiderSimulation();
  }

  void startRiderSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      progress += 0.03;

      riderLocation = LatLng(
        riderLocation.latitude + 0.0003,
        riderLocation.longitude + 0.0003,
      );

      if (progress >= 1.0) {
        _timer?.cancel();
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}