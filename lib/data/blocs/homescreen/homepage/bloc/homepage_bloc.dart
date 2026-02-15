import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:exotic/Test/HomepagesTesting/homepageService.dart';
import 'package:exotic/Test/HomepagesTesting/product.dart';
import 'package:exotic/data/domains/homesrceen/categories/categories.dart';
import 'package:exotic/data/domains/homesrceen/homepage/homepage.dart';
import 'package:exotic/data/models/categories.dart';
import 'package:exotic/utils/injection.dart';
import 'package:meta/meta.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(HomepageInitial()) {
    on<HomePageAdImagesFetchingEvent>((event, emit) async {
      // TODO: implement event handler
      emit(HomepageLoadingState());
      try {
        await Future.delayed(Duration(seconds: 3));
        List<String> _addImage = await getit<HomePageRepo>().getAdIamge();

        emit(HomepageAddImageSuccessState(imagePath: _addImage));
      } catch (e) {
        emit(HomepageErrorState(errMsg: e.toString()));
      }
    });
    on<HomePageCategoriesFetchingEvent>((event, emit) async {
      print(" EVENT: HomePageCategoriesFetchingEvent received");
      emit(HomepageLoadingState());
      try {
        final categories = event.categories;
        final filteredCat = categories.where((e) => e.parentId == "0").toList();
        print(" Fetched categories: ${filteredCat.length}");
        emit(HomePageCategoriesFetchedState(categories: filteredCat));
        print(" STATE: HomePageCategoriesFetchedState emitted");
      } catch (e) {
        emit(HomepageErrorState(errMsg: e.toString()));
      }
    });

    on<HomePageSectionFetchingEvent>((event, emit) async {
      emit(HomepageLoadingState());
      try {
        await Future.delayed(Duration(seconds: 3));
        emit(HomepageSectionFetchedState(data: event.productsitmes));
      } catch (e) {
        emit(HomepageErrorState(errMsg: e.toString()));
      }
    });
    on<HomepageApiFetcingEvent>((event, emit) async {
      HomepageService service = HomepageService();
      emit(HomepageLoadingState());
      try {
        Map<String, dynamic> data = await service.getHomePageData();
        emit(HomepageApiFetchedState(data: data));
      } catch (e) {
        emit(HomepageErrorState(errMsg: e.toString()));
      }
    });
  }
}
