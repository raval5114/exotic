abstract class FetchProductEvent {}

class FetchProductsRequested extends FetchProductEvent {}

class FetchingSingleProductEvent extends FetchProductEvent {
  final String productid;

  FetchingSingleProductEvent({required this.productid});
}
