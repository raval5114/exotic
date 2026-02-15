abstract class FetchProductState {}

class FetchProductInitial extends FetchProductState {}

class FetchProductLoading extends FetchProductState {}

class FetchProductSuccess extends FetchProductState {
  final List<Map<String, dynamic>> products;

  FetchProductSuccess({required this.products});
}

class FetchSingleProductSuccess extends FetchProductState {
  final Map<String, dynamic> product;

  FetchSingleProductSuccess({required this.product});
}

class FetchProductFailure extends FetchProductState {
  final String error;

  FetchProductFailure({required this.error});
}
