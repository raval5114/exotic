import 'package:exotic/controllers/Homescreen/Profile/profileScreenLogutSection.dart';
import 'package:exotic/controllers/Homescreen/Profile/profileScreenOptions.dart';
import 'package:exotic/controllers/Homescreen/Profile/src/profileScreenSection.dart';
import 'package:flutter/material.dart';

class Profilescreencontroller extends StatefulWidget {
  const Profilescreencontroller({super.key});

  @override
  State<Profilescreencontroller> createState() =>
      _ProfilescreencontrollerState();
}

class _ProfilescreencontrollerState extends State<Profilescreencontroller> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileScreenSection(),
          ProfileScreenOptions(),
          ProfileScreenLogoutSection(),
        ],
      ),
    );
  }
}
