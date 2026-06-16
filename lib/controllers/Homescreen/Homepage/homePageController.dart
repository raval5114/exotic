import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticPage.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/controllers/Homescreen/Homepage/sliver_homepage_controller.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:exotic/data/models/Interaction/abtract/interaction_shell.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
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
    context.read<InteractionTestProvider>().addInteraction(
      Exoticpage(
        tabBarName: '',
        pageName: 'Home page',
        isTabBar: false,
        createdAt: DateTime.now().toString(),
        interactionId: 3423,
        interactionType: 'page',
        updatedAt: DateTime.now().toString(),
      ),
    );
    // context.read<InteractionProvider>().addInteraction(
    //   interactionType: InteractionType.homeScreen,
    //   pageName: 'Home-screen',
    // );
    return ExoticHomeContent();
  }
}
