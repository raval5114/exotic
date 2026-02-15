import 'package:exotic/data/domains/product.dart';
import 'package:exotic/utils/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fetch_products_event.dart';
import 'fetch_products_state.dart';

class FetchProductBloc extends Bloc<FetchProductEvent, FetchProductState> {
  final productsRepository = getit<ProductService>();

  FetchProductBloc() : super(FetchProductInitial()) {
    on<FetchProductsRequested>(_onFetchProducts);
    on<FetchingSingleProductEvent>(_onFetchingSingleProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsRequested event,
    Emitter<FetchProductState> emit,
  ) async {
    emit(FetchProductLoading());

    try {
      final products = await productsRepository.fetchProductData();
      emit(FetchProductSuccess(products: products));
    } catch (e) {
      emit(FetchProductFailure(error: e.toString()));
    }
  }

  Future<void> _onFetchingSingleProducts(
    FetchingSingleProductEvent event,
    Emitter<FetchProductState> emit,
  ) async {
    emit(FetchProductLoading());

    try {
      final product = await productsRepository.fetchProductById(
        event.productid,
      );
      emit(FetchSingleProductSuccess(product: product));
    } catch (e) {
      emit(FetchProductFailure(error: e.toString()));
    }
  }
}
