import 'package:bloc/bloc.dart';
import 'package:exotic/data/domains/auth/auth.dart';
import 'package:exotic/data/domains/brands/brands.dart';
import 'package:exotic/data/domains/homesrceen/categories/categories.dart';
import 'package:exotic/data/domains/product.dart';
import 'package:exotic/data/models/categories.dart';
import 'package:exotic/data/models/user.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    AuthService auth = AuthService();
    SharedPreferences _prefs;
    on<SplashScreenInitialEvent>((event, emit) async {
      await Future.delayed(Duration(seconds: 2));
      emit(SplashScreenLoadingState());
      try {
        _prefs = await SharedPreferences.getInstance();

        String email = _prefs.getString('email') ?? "";
        String password = _prefs.getString('password') ?? "";
        debugPrint("email:${email}");
        debugPrint("password:${password}");
        Map<String, dynamic>? data = await auth.loginWithEmail(
          email: email,
          password: password,
        );

        //fetching categories
        final rawData = await getit<CategoriesRepo>().getCategories();

        // Defensive check to ensure we got a list
        if (rawData is! List) {
          throw Exception("Invalid data format from API: Expected List");
        }

        if (data!['status'] == "success") {
          final categories = rawData.map((e) => Category.fromJson(e)).toList();
          print("Yess categories are fetched");
          emit(
            SplashScreenSuccessedState(
              islogged: true,
              data: categories,
              user: User.fromJson(data['user']),
            ),
          );
        } else {
          emit(
            SplashScreenSuccessedState(
              islogged: false,
              data: [],
              user: User(
                customerId: 0,
                firstName: '',
                lastName: '',
                username: '',
                email: '',
                phone: '',
                profilePhotoUrl: '',
              ),
            ),
          );
        }
      } catch (e) {
        emit(SplashScrennErrorState(errMsg: e.toString()));
      }
    });
    on<ProductFetchingEvent>((event, emit) async {
      emit(SplashScreenLoadingState());
      try {
        List<Map<String, dynamic>> data =
            await getit<ProductService>().fetchProductData();
        debugPrint("data is fetched");
        emit(SplashScreenFetchedState(data: data));
      } catch (e) {
        emit(SplashScrennErrorState(errMsg: e.toString()));
      }
    });
  }
}
