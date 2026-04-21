import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exotic/data/domains/productViewer/productViewer.dart';

part 'product_viewer_event.dart';
part 'product_viewer_state.dart';

class ProductViewerBloc extends Bloc<ProductViewerEvent, ProductViewerState> {
  final ProductViewerRepo _repo;

  ProductViewerBloc(this._repo) : super(ProductViewerInitial()) {
    on<FetchProductDetailsEvent>((event, emit) async {
      emit(ProductViewerLoadingState());
      try {
        final result = await _repo.fetchProductDetails(event.url);
        emit(ProductViewerLoadedState(productDetails: result));
      } catch (e) {
        print("Error:${e}");
        if (e.toString().contains("No products found")) {
          emit(ProductViewerEmptyState());
        } else {
          emit(ProductViewerErrorState(errMsg: e.toString()));
        }
      }
    });
  }
}
