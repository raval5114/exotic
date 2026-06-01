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
      physics: const BouncingScrollPhysics(),
      child: ColoredBox(
        color: const Color(0xFFF1F3F6),
        child: Column(
          children: [
            ProfileScreenSection(),
            const SizedBox(height: 2),
            ProfileScreenOptions(),
            const SizedBox(height: 2),
            ProfileScreenLogoutSection(),
          ],
        ),
      ),
    );
  }
}
