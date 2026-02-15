import 'package:bloc/bloc.dart';
import 'package:exotic/data/domains/vendorStore/vendorStore.dart';
import 'package:meta/meta.dart';

part 'vender_event.dart';
part 'vender_state.dart';

class VenderBloc extends Bloc<VenderEvent, VenderState> {
  VenderBloc() : super(VenderInitial()) {
    on<VenderStoreDataFetchingEvent>((event, emit) async {
      emit(VenderLoadingState());
      try {
        VendorstoreRepo _repo = VendorstoreRepo();
        List<Map<String, dynamic>> fetchedData = await _repo.fetchVendorData();
        await Future.delayed(Duration(seconds: 5));
        emit(VendorStoreDataFetchedState(data: fetchedData));
      } catch (e) {
        emit(VendorStoreDataErrorState(errMsg: e.toString()));
      }
    });
  }
}
