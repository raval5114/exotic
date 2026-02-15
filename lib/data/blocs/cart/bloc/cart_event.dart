part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

enum ActionType { increase, decrease }

final class CartFetchingEvent extends CartEvent {
  final String cid;
  CartFetchingEvent({required this.cid});
}

class CartAddingEvent extends CartEvent {
  final String cid;
  final String pid;
  final String? pvid; // 👈 nullable
  final String quantity;

  CartAddingEvent({
    required this.cid,
    required this.pid,
    this.pvid,
    required this.quantity,
  });
}

final class CartDeletingEvent extends CartEvent {
  final String cartid;

  CartDeletingEvent({required this.cartid});
}

final class CartUpdateEvent extends CartEvent {
  final String cartid;
  final ActionType action;

  CartUpdateEvent({required this.cartid, required this.action});
}
