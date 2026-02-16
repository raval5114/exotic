import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/providers/categories_provider.dart';
import 'package:exotic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 41,
                        height: 41,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(width: 30, height: 8, color: Colors.white),
                    ],
                  ),
                );
              },
            );
          }

          if (state is HomePageCategoriesFetchedState) {
            print("Yes its working");
            final categories = state.categories;

            if (categories.isEmpty) {
              return const Center(child: Text("No categories available"));
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];

                return Column(
                  children: [
                    Container(
                      width: 41,
                      height: 41,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        "$IMAGELINK/${category.photo!}",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.name,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
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
