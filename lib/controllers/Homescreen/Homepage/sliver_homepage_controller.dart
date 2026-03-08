import 'package:exotic/controllers/Homescreen/Homepage/src/sliver_app_bar.dart';
import 'package:exotic/controllers/Homescreen/Homepage/src/sliver_body.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/models/homepage_page_model.dart';
import 'package:flutter/material.dart';
import 'package:exotic/data/providers/homepage_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExoticHomeContent extends StatefulWidget {
  const ExoticHomeContent({super.key});

  @override
  State<ExoticHomeContent> createState() => _ExoticHomeContentState();
}

class _ExoticHomeContentState extends State<ExoticHomeContent>
    with TickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    context.read<HomepageBloc>().add(HomepagePagesFetchingEvent());
  }

  void _initController(int length, List tabs) {
    _controller?.dispose();

    _controller = TabController(length: length, vsync: this, initialIndex: 0);

    _controller!.addListener(() {
      if (!_controller!.indexIsChanging) {
        final provider = context.read<HomepageProvider>();
        final index = _controller!.index;

        provider.setSelectedIndex(index);

        context.read<HomepageBloc>().add(
          HomepageApiFetcingEvent(Slug: provider.tabs[index].slug),
        );

        print("API fired for $index");
      }
    });

    // 🔥 Fire first tab API immediately
    context.read<HomepageBloc>().add(
      HomepageApiFetcingEvent(Slug: tabs[0].slug),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomepageBloc, HomepageState>(
      listener: (context, state) {
        if (state is HomepagePagesFetchedState) {
          context.read<HomepageProvider>().setTabs(
            state.data.map((e) => HomepagePageModel.fromJson(e)).toList(),
          );
        }

        if (state is HomepageErrorState) {
          debugPrint(state.errMsg);
          // ScaffoldMessenger.of(
          //   context,
          // ).showSnackBar(SnackBar(content: Text("Error: ${state.errMsg}")));
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final tabs = context.watch<HomepageProvider>().tabs;

    print("Tabs length: ${tabs.length}");

    if (tabs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller == null || _controller!.length != tabs.length) {
      _initController(tabs.length, tabs);
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [ExoticSliverAppBar(controller: _controller!)];
      },
      body: ExoticSliverBody(tabs: tabs, controller: _controller!),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
