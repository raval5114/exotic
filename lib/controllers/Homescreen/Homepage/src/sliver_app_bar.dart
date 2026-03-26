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
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                          size: 32,
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
                        isScrollable: true,
                        physics: const BouncingScrollPhysics(),
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black87,
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        indicator: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        splashBorderRadius: BorderRadius.circular(24),
                        tabs:
                            tabs
                                .map(
                                  (e) => Tab(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Text(e.title ?? ""),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
            ),
          ),
        );
      },
    );
  }
}
