part of 'product_viewer_bloc.dart';

sealed class ProductViewerEvent extends Equatable {
  const ProductViewerEvent();

  @override
  List<Object> get props => [];
}

class FetchProductDetailsEvent extends ProductViewerEvent {
  final String url;
  const FetchProductDetailsEvent({required this.url});

  @override
  List<Object> get props => [url];
}
