import 'package:exotic/data/blocs/homescreen/categories/bloc/categories_bloc.dart';
import 'package:exotic/data/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesBuilder extends StatefulWidget {
  const CategoriesBuilder({super.key});

  @override
  State<CategoriesBuilder> createState() => _CategoriesBuilderState();
}

class _CategoriesBuilderState extends State<CategoriesBuilder> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CategoriesBloc>().add(
      CategoriesPageCategoriesFetchingEvent(
        categories: context.read<CategoriesProvider>().topLevelCategories,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CategoriesPageCategoriesLoadingState) {
          return Container(
            color: Colors.grey.shade200,
            child: ListView.builder(
              itemCount: 12, // Placeholder item count
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 41,
                          height: 57,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(width: 41, height: 12, color: Colors.white),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        if (state is CategoriesPageCategoriesFetchedState) {
          return Container(
            color: Colors.grey.shade200,
            child: ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.read<CategoriesProvider>().setCurrentCategory(
                      state.data[index],
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        child: Container(
                          width: 41,
                          height: 57,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              state.data[index].photo!,
                              width: 45,
                              height: 41,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 41,
                        height: 30,
                        child: Text(
                          state.data[index].name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          );
        }

        if (state is CategoriesPageErrorState) {
          debugPrint("${state.errMsg}");
          return Center(child: Text(state.errMsg));
        }

        return const SizedBox();
      },
    );
  }
}
