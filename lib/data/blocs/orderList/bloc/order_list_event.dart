part of 'order_list_bloc.dart';

@immutable
class OrderListEvent {}

class OderListProductSearchingEvent extends OrderListEvent {
  final String productName;

  OderListProductSearchingEvent({required this.productName});
}
