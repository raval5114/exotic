import 'package:bloc/bloc.dart';
import 'package:exotic/data/domains/homesrceen/homepage/homepage.dart';
import 'package:exotic/data/models/categories.dart';
import 'package:exotic/utils/injection.dart';
import 'package:meta/meta.dart';
part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(HomepageInitial()) {
    final Map<String, Map<String, dynamic>> _pagesCache = {};
    final Map<String, bool> _loading = {};
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
      // ✅ If already cached, return immediately
      if (_pagesCache.containsKey(event.Slug)) {
        emit(
          HomepageApiFetchedState(
            slug: event.Slug,
            data: _pagesCache[event.Slug]!,
          ),
        );
        return;
      }

      // ✅ Avoid duplicate loading
      if (_loading[event.Slug] == true) return;

      _loading[event.Slug] = true;
      emit(HomepageTabLoadingState(event.Slug));

      try {
        final Map<String, dynamic> data = await getit<HomePageRepo>()
            .getHomePageData(slug: event.Slug);

        _pagesCache[event.Slug] = data;
        _loading[event.Slug] = false;

        emit(HomepageApiFetchedState(slug: event.Slug, data: data));
      } catch (e) {
        _loading[event.Slug] = false;
        emit(HomepageErrorState(errMsg: e.toString()));
      }
    });
    on<HomepagePagesFetchingEvent>((event, emit) async {
      try {
        emit(HomepageLoadingState());
        List<Map<String, dynamic>> data =
            await getit<HomePageRepo>().getHomepageTabsData();
        emit(HomepagePagesFetchedState(data: data));
      } catch (e) {
        emit(HomepageErrorState(errMsg: e.toString()));
      }
    });
  }
}
