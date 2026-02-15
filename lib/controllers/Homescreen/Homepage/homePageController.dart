import 'package:exotic/controllers/Homescreen/Homepage/lazyloading/homepage_skeleton.dart';
import 'package:exotic/controllers/Homescreen/Homepage/pageComponent.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:exotic/data/domains/homesrceen/categories/categories.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/categories.dart';
import 'package:exotic/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
    context.read<HomepageBloc>().add(HomepageApiFetcingEvent());
    final rawData = await getit<CategoriesRepo>().getCategories();
    final categories = rawData.map((e) => Category.fromJson(e)).toList();

    if (!mounted) return;

    context.read<SearchProductBloc>().add(SearchProductMetaDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageBloc, HomepageState>(
      builder: (context, state) {
        if (state is HomepageLoadingState) {
          return const HomepageSkeleton();
        }

        if (state is HomepageApiFetchedState) {
          final page = Pagemodel.fromJson(state.data);

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Pagecomponent(pageData: page),
          );
        }

        if (state is HomepageErrorState) {
          return Center(child: Text(state.errMsg));
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder:
            (_, __) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
      ),
    );
  }
}
