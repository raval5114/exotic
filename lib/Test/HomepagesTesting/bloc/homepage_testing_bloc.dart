import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exotic/Test/HomepagesTesting/homepageService.dart';

part 'homepage_testing_event.dart';
part 'homepage_testing_state.dart';

class HomepageTestingBloc
    extends Bloc<HomepageTestingEvent, HomepageTestingState> {
  HomepageTestingBloc() : super(HomepageTestingInitial()) {
    on<HomepageTestingEvent>((event, emit) async {
      emit(HomepageTestingLoadingState());
      try {
        HomepageServiceTesting service = HomepageServiceTesting();
        Map<String, dynamic> data = await service.getHomePageData();
        emit(HomepageTestingSuccessState(data: data));
      } catch (e) {
        emit(HomepageErrorState(errMsg: e.toString()));
      }
    });

    on<HomepagePageTitleFetchingEvent>((event, emit) async {
      emit(HomepageTestingLoadingState());
      try {
        HomepageServiceTesting service = HomepageServiceTesting();
        List<Map<String, dynamic>> data = await service.getHomePageTabData();
        emit(HomepageTestingFetchingPageTitleSuccessState(data: data));
      } catch (e) {
        emit(HomepageErrorState(errMsg: e.toString()));
      }
    });
  }
}
