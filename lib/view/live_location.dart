import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_ordering_app/viewmodel/location_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
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

              // ⬅️ BACK BUTTON
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 📦 TOP CARD
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 64, 12, 12),
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
                  child: Text(
                    "Start Live Tracking",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
