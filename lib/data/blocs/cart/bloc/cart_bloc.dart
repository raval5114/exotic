import 'package:bloc/bloc.dart';
import 'package:exotic/data/domains/cart/cart_service.dart';
import 'package:exotic/utils/injection.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartFetchingEvent>((event, emit) async {
      emit(CartLoadingState());
      try {
        Map<String, dynamic> data = await getit<CartService>().getFromCart(
          int.parse(event.cid),
        );
        print(data);
        emit(CartFetchingSuccessState(data: data));
      } catch (e) {
        emit(CartErrorState(errMsg: e.toString()));
      }
    });
    on<CartAddingEvent>((event, emit) async {
      emit(CartLoadingState());
      try {
        bool isAdded = await getit<CartService>().addToCart(
          int.parse(event.cid),
          int.parse(event.pid),
          event.pvid != null ? int.parse(event.pvid!) : null, // 👈 FIX
          int.parse(event.quantity),
        );

        if (isAdded) {
          emit(CartAddingSuccessState());
        } else {
          emit(CartErrorState(errMsg: "Something Went Wrong"));
        }
      } catch (e) {
        emit(CartErrorState(errMsg: e.toString()));
      }
    });

    on<CartDeletingEvent>((event, emit) async {
      emit(CartLoadingState());
      try {
        bool isdeleted = await getit<CartService>().cartDelete(
          int.parse(event.cartid),
        );
        if (isdeleted) {
          emit(CartDeletationSuccessState(CartId: int.parse(event.cartid)));
        } else {
          emit(CartErrorState(errMsg: "Something Went Wrong"));
        }
      } catch (e) {
        emit(CartErrorState(errMsg: e.toString()));
      }
    });
    on<CartUpdateEvent>((event, emit) async {
      emit(CartLoadingState());
      try {
        bool isUpdated = await getit<CartService>().updateInCart(
          event.cartid,
          event.action.name,
        );
        if (isUpdated) {
          emit(
            CartUpdateSuccessState(
              cartid: event.cartid,
              action: event.action.name,
            ),
          );
        } else {
          emit(CartErrorState(errMsg: "Somthing Went Wrong"));
        }
      } catch (e) {
        emit(CartErrorState(errMsg: e.toString()));
      }
    });
  }
}
