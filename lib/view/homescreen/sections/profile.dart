import 'package:exotic/controllers/Homescreen/Profile/src/profileScreenController.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Profilescreencontroller(),
    );
  }
}
