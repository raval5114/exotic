import 'package:exotic/controllers/Homescreen/Homepage/homePageController.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeScreenMainController());
  }
}
