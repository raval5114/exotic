import 'package:exotic/controllers/address/addAddressComponent.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressMainComponent extends StatefulWidget {
  const AddAddressMainComponent({super.key});

  @override
  State<AddAddressMainComponent> createState() =>
      _AddAddressMainComponentState();
}

class _AddAddressMainComponentState extends State<AddAddressMainComponent> {
  LatLng _currentPosition = const LatLng(28.6139, 77.2090); // Default to New Delhi
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 14.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                onCameraMove: (CameraPosition position) {
                  _currentPosition = position.target;
                },
                onCameraIdle: () {
                  // Get the lat and lang from the pinned location of the map
                  debugPrint("Pinned Location: ${_currentPosition.latitude}, ${_currentPosition.longitude}");
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 35.0),
                child: Icon(
                  Icons.location_pin,
                  size: 40.0,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 6,
          child: AddAddressComponent(),
        ),
      ],
    );
  }
}
