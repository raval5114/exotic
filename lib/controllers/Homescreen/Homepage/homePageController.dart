import 'package:exotic/controllers/Homescreen/Homepage/sliver_homepage_controller.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenMainController extends StatefulWidget {
  const HomeScreenMainController({super.key});

  @override
  State<HomeScreenMainController> createState() =>
      _HomeScreenMainControllerState();
}

class _HomeScreenMainControllerState extends State<HomeScreenMainController> {
  @override
  void initState() {
    super.initState();
    _initializeMetaData();
  }

  Future<void> _initializeMetaData() async {
    context.read<HomepageBloc>().add(HomepagePagesFetchingEvent());

    if (!mounted) return;

    context.read<SearchProductBloc>().add(SearchProductMetaDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ExoticHomeContent();
  }
}
