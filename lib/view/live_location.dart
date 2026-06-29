import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_ordering_app/viewmodel/location_view_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          body: Stack(
            children: [
              // 🗺️ REAL OPENSTREETMAP
              FlutterMap(
                options: MapOptions(
                  initialCenter: vm.userLocation,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                  ),

                  // 📍 ROUTE LINE (FAKE DELIVERY PATH)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [vm.userLocation, vm.riderLocation],
                        strokeWidth: 4,
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  // 📍 MARKERS
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: vm.userLocation,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.home,
                          color: Colors.red,
                          size: 35,
                        ),
                      ),
                      Marker(
                        point: vm.riderLocation,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.delivery_dining,
                          color: Colors.orange,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 📦 TOP CARD
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.delivery_dining, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            vm.progress < 0.3
                                ? "Rider is coming..."
                                : vm.progress < 0.7
                                ? "On the way 🚴"
                                : "Almost there 🏠",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "${(vm.progress * 100).toInt()}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 📦 START BUTTON (simulate)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: vm.initLocation,
                  child: const Text("Start Live Tracking"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
