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
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: (state.data[index].photo != null && state.data[index].photo!.isNotEmpty) 
                            ? Image.network(
                                state.data[index].photo!,
                                fit: BoxFit.cover,
                                errorBuilder: (c,e,s) => Icon(Icons.category, color: Colors.grey.shade400, size: 24)
                              )
                            : Icon(Icons.category, color: Colors.grey.shade400, size: 24),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          state.data[index].name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
