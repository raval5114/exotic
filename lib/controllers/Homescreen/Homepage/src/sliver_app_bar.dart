import 'package:exotic/controllers/Homescreen/Homepage/src/build_search_bar.dart';
import 'package:exotic/data/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ExoticSliverAppBar extends StatelessWidget {
  const ExoticSliverAppBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageProvider>(
      builder: (context, provider, _) {
        final tabs = provider.tabs;

        return SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          pinned: true,
          expandedHeight: 150,
          toolbarHeight: 0,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(child: BuildSearchBar()),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => context.push('/wishlist'),
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              child:
                  tabs.isEmpty
                      ? const SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                      : TabBar(
                        controller: controller,
                        isScrollable: true, // 👈 important if many tabs
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black54,
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(width: 3, color: Colors.black),
                          insets: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        tabs:
                            tabs.map((e) => Tab(text: e.title ?? "")).toList(),
                      ),
            ),
          ),
        );
      },
    );
  }
}
