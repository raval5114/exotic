import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesGrid extends StatefulWidget {
  final String? tabName;
  const CategoriesGrid({super.key, this.tabName});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title
        const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: Text(
            "Shop by Category",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
        ),

        BlocBuilder<HomepageBloc, HomepageState>(
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
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 40,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
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
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return _CategoryItem(
                    name: category.name,
                    imageUrl: category.url,
                  );
                },
              );
            }

            /// Error state
            if (state is HomepageErrorState) {
              return Center(child: Text("Error: ${state.errMsg}"));
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _CategoryItem({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<InteractionTestProvider>().addInteraction(
          ExotichomepageElement(
            createdAt: DateTime.now().toString(),
            interactionId: 1,
            interactionType: "homepageElement",
            updatedAt: DateTime.now().toString(),
            elementName: name,
            elementType: "category",
            tabBarName: "tabBarName",
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  imageUrl.isNotEmpty
                      ? Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.category_rounded,
                              color: Color(0xFF7C3AED),
                              size: 24,
                            ),
                      )
                      : const Icon(
                        Icons.category_rounded,
                        color: Color(0xFF7C3AED),
                        size: 24,
                      ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: Color(0xFF374151),
              letterSpacing: -0.1,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
