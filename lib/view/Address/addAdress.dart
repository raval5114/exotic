import 'package:exotic/controllers/address/addAddressComponent.dart';
import 'package:exotic/controllers/address/addAddressMainComponent.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Address'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AddAddressMainComponent(),
    );
  }
}
