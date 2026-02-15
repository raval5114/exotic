import 'package:exotic/Test/HomepagesTesting/product.dart';
import 'package:exotic/controllers/Homescreen/Homepage/homePageController.dart';
import 'package:exotic/controllers/Homescreen/Homepage/pageComponent.dart';
import 'package:exotic/controllers/Homescreen/Homepage/productGridVertical.dart';
import 'package:exotic/controllers/Homescreen/Homepage/productGridVertical2.dart';
import 'package:exotic/controllers/Homescreen/Homepage/product_gallery.dart';
import 'package:exotic/controllers/Homescreen/Homepage/rowPage.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/Homepage/elements/Product_grid.dart';
import 'package:exotic/data/models/Homepage/elements/product_gallery.dart';
import 'package:exotic/data/models/Homepage/elements/product_grid_vertical.dart';
import 'package:exotic/data/models/Homepage/elements/product_grid_vertical_2.dart';
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
