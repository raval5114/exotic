part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoadingState extends CartState {}

final class CartFetchingSuccessState extends CartState {
  final Map<String, dynamic> data;

  CartFetchingSuccessState({required this.data});
}

final class CartAddingSuccessState extends CartState {}

final class CartDeletationSuccessState extends CartState {
  final int CartId;

  CartDeletationSuccessState({required this.CartId});
}

final class CartUpdateSuccessState extends CartState {
  final String cartid;
  final String action;
  CartUpdateSuccessState({required this.action, required this.cartid});
}

final class CartErrorState extends CartState {
  final String errMsg;

  CartErrorState({required this.errMsg});
}
