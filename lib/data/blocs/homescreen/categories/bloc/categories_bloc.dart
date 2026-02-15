import 'package:bloc/bloc.dart';
import 'package:exotic/data/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesInitial()) {
    on<CategoriesPageCategoriesFetchingEvent>(_onCategoriesFetching);
    on<CategoriesPageSubcategoriesFetchingEvent>(_onSubcategoriesFetching);
  }

  Future<void> _onCategoriesFetching(
    CategoriesPageCategoriesFetchingEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesPageCategoriesLoadingState());
    try {
      final rawData = event.categories;
      // Defensive check to ensure we got a list
      if (rawData is! List) {
        throw Exception("Invalid data format from API: Expected List");
      }

      //final categories =
      //rawData.map((e) => Category.fromJson(e)).toList();
      emit(CategoriesPageCategoriesFetchedState(data: rawData));
    } catch (e, stackTrace) {
      debugPrint("CategoriesBloc error: $e\n$stackTrace");
      emit(CategoriesPageErrorState(errMsg: e.toString()));
    }
  }

  Future<void> _onSubcategoriesFetching(
    CategoriesPageSubcategoriesFetchingEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesPageCategoriesLoadingState());
    try {
      emit(CategoriesPageSubcategoriesFetchedState(data: event.data));
    } catch (e) {
      emit(CategoriesPageErrorState(errMsg: e.toString()));
    }
  }
}
