import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/auth/src/alertDailog.dart';
import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/domains/homesrceen/categories/categories.dart';
import 'package:exotic/data/models/categories.dart';
import 'package:exotic/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesTesting extends StatefulWidget {
  const CategoriesTesting({super.key});

  @override
  State<CategoriesTesting> createState() => _CategoriesTestingState();
}

class _CategoriesTestingState extends State<CategoriesTesting> {
  void initalTestingIntials() async {
    var rawData = await getit<CategoriesRepo>().getCategories();
    final categories = rawData.map((e) => Category.fromJson(e)).toList();
    context.read<HomepageBloc>().add(
      HomePageCategoriesFetchingEvent(categories: categories),
    );
  }

  @override
  void initState() {
    super.initState();
    initalTestingIntials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories Data Receiving working")),
      body: Center(
        child: ElevatedButton(
          onPressed:
              () => showCustomAlertBox(
                context: context,
                message: "Yes its working",
                type: AlertType.success,
                errors: ["This is the error 1", "This is the Error 2"],
                onOkay: () {
                  context.pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("yes its working")));
                },
              ),
          child: Text("CLick me"),
        ),
      ),
    );
  }
}
