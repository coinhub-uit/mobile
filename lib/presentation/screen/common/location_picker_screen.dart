import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:geocoding/geocoding.dart";
import "package:latlong2/latlong.dart";

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? selectedLatLng;
  final mapController = MapController();

  final defaultLocation = LatLng(10.762622, 106.660172); // SG default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick a location")),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: defaultLocation,
          initialZoom: 15,
          onTap: (tapPosition, point) {
            setState(() {
              selectedLatLng = point;
            });
          },
        ),

        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.coinhub.coinhub",
          ),
          if (selectedLatLng != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 40,
                  height: 40,
                  point: selectedLatLng!,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedLatLng != null) {
            // Try reverse geocoding
            List<Placemark> placemarks = await placemarkFromCoordinates(
              selectedLatLng!.latitude,
              selectedLatLng!.longitude,
            );

            // Build readable address
            Placemark place = placemarks.first;
            String address =
                "${place.street}, ${place.locality}, ${place.administrativeArea}";

            // Return both LatLng and address as Map
            Navigator.pop(context, {
              "location": selectedLatLng,
              "address": address,
            });
          }
        },
        label: const Text("Confirm"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
