part of 'vender_bloc.dart';

@immutable
sealed class VenderState {}

final class VenderInitial extends VenderState {}

final class VenderLoadingState extends VenderState {}

final class VendorStoreDataFetchedState extends VenderState {
  final List<Map<String, dynamic>> data;

  VendorStoreDataFetchedState({required this.data});
}

final class VendorStoreDataErrorState extends VenderState {
  final String errMsg;

  VendorStoreDataErrorState({required this.errMsg});
}
