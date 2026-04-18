part of 'order_list_bloc.dart';

@immutable
sealed class OrderListState {}

final class OrderListInitial extends OrderListState {}

final class OrderShowingLoadingState extends OrderListState {}

final class OrderShowningSuccessState extends OrderListState {
  final List<OrderListModel> data;

  OrderShowningSuccessState({required this.data});
}

final class OrderShowningErrorState extends OrderListState {
  final String errMsg;

  OrderShowningErrorState({required this.errMsg});
}
