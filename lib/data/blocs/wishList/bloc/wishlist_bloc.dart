import 'package:exotic/data/domains/cart/cart_service.dart';
import 'package:exotic/data/domains/wishlist/wishlist.dart';
import 'package:exotic/utils/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final wishlistRepo = getit<WishlistService>();

  WishlistBloc() : super(WishlistInitialState()) {
    on<FetchWishlistEvent>(_fetchWishlist);
    on<AddWishlistEvent>(_addWishlist);
    on<RemoveWishlistEvent>(_removeWishlist);
    on<RemoveWishlistByProductEvent>(_removeWishlistByProduct);
    on<AddWishlistItemToCartEvent>(_addWishlistItemToCart);
  }
  Future<void> _addWishlistItemToCart(
    AddWishlistItemToCartEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoadingState());

    try {
      if (event.customerId == null) {
        emit(const WishlistFailureState("Customer not logged in"));
        return;
      }

      final isAdded = await getit<CartService>().addToCart(
        event.customerId!,
        event.productId,
        event.variantId,
        1,
      );

      if (isAdded) {
        emit(WishlistAddedToCartState(event.productId));
      } else {
        emit(const WishlistFailureState("Failed to add item to cart"));
      }
    } catch (e) {
      emit(WishlistFailureState(e.toString()));
    }
  }

  Future<void> _fetchWishlist(
    FetchWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoadingState());

    try {
      final response = await wishlistRepo.fetchWishlist(event.cid);

      emit(
        WishlistSuccessState(
          wishlist: response['data'], //  LIST
        ),
      );
    } catch (e) {
      emit(WishlistFailureState(e.toString()));
    }
  }

  Future<void> _addWishlist(
    AddWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoadingState());
    try {
      await wishlistRepo.addWishlist(event.cid, event.pid);
      emit(const WishlistActionSuccessState());
    } catch (e) {
      emit(WishlistFailureState(e.toString()));
    }
  }

  Future<void> _removeWishlist(
    RemoveWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoadingState());
    try {
      bool isRemoved = await wishlistRepo.deleteWishlist(event.wishlistid);
      if (isRemoved) {
        emit(WishlistActionRemovedState(wishlistid: event.wishlistid));
      } else {
        emit(const WishlistFailureState("Something Went Wrong"));
      }
    } catch (e) {
      emit(WishlistFailureState(e.toString()));
    }
  }

  Future<void> _removeWishlistByProduct(
    RemoveWishlistByProductEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoadingState());
    try {
      final response = await wishlistRepo.fetchWishlist(event.cid);
      final rawData = response['data'];
      final List data = rawData is List ? rawData : [];

      dynamic targetItem;
      for (var element in data) {
        if (element is Map &&
            element['product_id'].toString() == event.pid.toString()) {
          targetItem = element;
          break;
        }
      }

      if (targetItem != null &&
          targetItem is Map &&
          targetItem.containsKey('wishlist_id')) {
        final wishlistId = int.parse(targetItem['wishlist_id'].toString());
        bool isRemoved = await wishlistRepo.deleteWishlist(wishlistId);
        if (isRemoved) {
          emit(WishlistActionRemovedState(wishlistid: wishlistId));
        } else {
          emit(const WishlistFailureState("Failed to remove from wishlist"));
        }
      } else {
        // Item is already not in wishlist
        emit(WishlistActionRemovedState(wishlistid: 0));
      }
    } catch (e) {
      emit(WishlistFailureState(e.toString()));
    }
  }
}
