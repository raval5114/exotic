import 'package:exotic/controllers/Homescreen/Categories/categoriesBuilder.dart';
import 'package:exotic/controllers/Homescreen/Categories/subCategoriesBuilder.dart';
import 'package:exotic/controllers/src/appbar.dart';
import 'package:exotic/data/blocs/homescreen/categories/bloc/categories_bloc.dart';
import 'package:exotic/data/models/Interaction/interactions.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesComponent extends StatefulWidget {
  const CategoriesComponent({super.key});

  @override
  State<CategoriesComponent> createState() => _CategoriesComponentState();
}

class _CategoriesComponentState extends State<CategoriesComponent> {
  @override
  Widget build(BuildContext context) {
    context.read<InteractionProvider>().addInteraction(
      interactionType: InteractionType.categoryPage,
      pageName: 'category-page',
    );
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: ExoticAppBar(),
          body: Row(
            children: const [
              Expanded(flex: 1, child: CategoriesBuilder()),
              Expanded(flex: 3, child: SubCategoriesBuilder()),
            ],
          ),
        );
      },
    );
  }
}
