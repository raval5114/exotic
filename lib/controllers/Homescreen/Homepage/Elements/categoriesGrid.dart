import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesGrid extends StatefulWidget {
  const CategoriesGrid({super.key});

  @override
  State<CategoriesGrid> createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  @override
  void initState() {
    super.initState();
    context.read<HomepageBloc>().add(
      HomePageCategoriesFetchingEvent(
        categories: context.read<CategoriesProvider>().categories,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<HomepageBloc, HomepageState>(
        buildWhen:
            (previous, current) =>
                current is HomepageLoadingState ||
                current is HomePageCategoriesFetchedState ||
                current is HomepageErrorState,
        builder: (context, state) {
          /// Loading shimmer
          if (state is HomepageLoadingState) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(width: 40, height: 10, color: Colors.white),
                    ],
                  ),
                );
              },
            );
          }

          if (state is HomePageCategoriesFetchedState) {
            final categories = state.categories;

            if (categories.isEmpty) {
              return const Center(child: Text("No categories available"));
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length > 10 ? 10 : categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];

                return Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: category.url.isNotEmpty? Image.asset(
                          category.url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.category_rounded, color: Colors.grey),
                        ) : const Icon(Icons.category_rounded, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black87,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            );
          }

          /// 🔹 Error state
          if (state is HomepageErrorState) {
            return Center(child: Text("Error: ${state.errMsg}"));
          }

          /// 🔹 Fallback
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
