import 'package:exotic/controllers/Homescreen/Homepage/pageComponent.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/homepage_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ExoticSliverBody extends StatelessWidget {
  final List<HomepagePageModel> tabs;

  const ExoticSliverBody({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return TabBarView(
      controller: controller,
      children:
          tabs.map((tab) {
            return BlocBuilder<HomepageBloc, HomepageState>(
              buildWhen: (previous, current) {
                if (current is HomepageTabLoadingState) {
                  return current.slug == tab.slug;
                }
                if (current is HomepageApiFetchedState) {
                  return current.slug == tab.slug;
                }
                return false;
              },
              builder: (context, state) {
                if (state is HomepageTabLoadingState &&
                    state.slug == tab.slug) {
                  return _buildShimmerGrid();
                }

                if (state is HomepageApiFetchedState &&
                    state.slug == tab.slug) {
                  final Map<String, dynamic> pageData = state.data;

                  return Pagecomponent(pageData: Pagemodel.fromJson(pageData));
                }

                return const SizedBox();
              },
            );
          }).toList(),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      },
    );
  }
}
