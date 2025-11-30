import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const CameraPosition _initial = CameraPosition(
    target: LatLng(10.8231, 106.6297), // TP.HCM
    zoom: 14,
  );

  GoogleMapController? _controller;
  LatLng _selected = const LatLng(10.8231, 106.6297);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bản đồ Google Maps')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initial,
              onMapCreated: (c) => _controller = c,
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selected,
                  infoWindow: const InfoWindow(title: 'Vị trí đã chọn'),
                ),
              },
              onTap: (pos) {
                setState(() {
                  _selected = pos;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            color: Colors.white,
            child: Text(
              'Lat: ${_selected.latitude.toStringAsFixed(5)}, '
              'Lng: ${_selected.longitude.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
