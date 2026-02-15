part of 'vender_bloc.dart';

@immutable
sealed class VenderEvent {}

final class VenderStoreDataFetchingEvent extends VenderEvent {}
