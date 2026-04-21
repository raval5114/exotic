part of 'product_viewer_bloc.dart';

sealed class ProductViewerState extends Equatable {
  const ProductViewerState();
  
  @override
  List<Object> get props => [];
}

final class ProductViewerInitial extends ProductViewerState {}

final class ProductViewerEmptyState extends ProductViewerState {}

final class ProductViewerLoadingState extends ProductViewerState {}

final class ProductViewerLoadedState extends ProductViewerState {
  final Map<String, dynamic> productDetails;

  const ProductViewerLoadedState({required this.productDetails});

  @override
  List<Object> get props => [productDetails];
}

final class ProductViewerErrorState extends ProductViewerState {
  final String errMsg;

  const ProductViewerErrorState({required this.errMsg});

  @override
  List<Object> get props => [errMsg];
}
