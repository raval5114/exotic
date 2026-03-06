import 'package:exotic/data/blocs/homescreen/homepage/bloc/homepage_bloc.dart';
import 'package:exotic/data/models/homepage_page_model.dart';
import 'package:exotic/data/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomepageTestingWithService extends StatelessWidget {
  const HomepageTestingWithService({super.key});

  @override
  Widget build(BuildContext context) {
    return HomepageTestingServiceComponent();
  }
}

class HomepageTestingServiceComponent extends StatefulWidget {
  const HomepageTestingServiceComponent({super.key});

  @override
  State<HomepageTestingServiceComponent> createState() =>
      _HomepageTestingServiceComponentState();
}

class _HomepageTestingServiceComponentState
    extends State<HomepageTestingServiceComponent> {
  @override
  void initState() {
    super.initState();
    context.read<HomepageBloc>().add(HomepagePagesFetchingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage Testing Component", style: TextStyle()),
        centerTitle: true,
      ),
      body: BlocListener<HomepageBloc, HomepageState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is HomepageLoadingState) {
            debugPrint("Loading state");
          }
          if (state is HomepagePagesFetchedState) {
            List<HomepagePageModel> pages =
                state.data.map((e) => HomepagePageModel.fromJson(e)).toList();
            context.read<HomepageProvider>().setTabs(pages);
            debugPrint("Data Fetched State:${pages.map((e) => e.slug)}");
          }
          if (state is HomepageErrorState) {
            debugPrint(state.errMsg);
          }
        },
        child: Center(),
      ),
    );
  }
}
