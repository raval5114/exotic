import 'package:flutter/material.dart';
import 'package:exotic/controllers/address/updateAddressComponent.dart';
import 'package:exotic/data/models/address_model.dart';

class UpdateAddress extends StatelessWidget {
  final Address address;
  const UpdateAddress({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return UpdateAddressComponent(address: address);
  }
}
