import 'package:bloc/bloc.dart';
import 'package:exotic/data/domains/orderList/orderList.dart';
import 'package:meta/meta.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderListBloc() : super(OrderListInitial()) {
    on<OrderListEvent>((event, emit) async {
      emit(OrderShowingLoadingState());
      try {
        OrderlistRepo _repo = OrderlistRepo();
        List<Map<String, dynamic>> data = await _repo.fetchUserOderList();
        emit(OrderShowningSuccessState(data: data));
      } catch (e) {
        emit(OrderShowningErrorState(errMsg: e.toString()));
      }
    });
    on<OderListProductSearchingEvent>((event, emit) async {
      emit(OrderShowingLoadingState());
      try {} catch (e) {
        emit(OrderShowningErrorState(errMsg: e.toString()));
      }
    });
  }
}
