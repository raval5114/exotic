import 'package:exotic/controllers/Homescreen/Homepage/homePageController.dart';
import 'package:flutter/material.dart';

class HomepageTestingWithService extends StatelessWidget {
  const HomepageTestingWithService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home page Testing WIth service")),
      body: HomepageTestingWithServiceComponent(),
    );
  }
}

class HomepageTestingWithServiceComponent extends StatefulWidget {
  const HomepageTestingWithServiceComponent({super.key});

  @override
  State<HomepageTestingWithServiceComponent> createState() =>
      _HomepageTestingWithServiceComponentState();
}

class _HomepageTestingWithServiceComponentState
    extends State<HomepageTestingWithServiceComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: HomeScreenMainController(),
    );
  }
}
