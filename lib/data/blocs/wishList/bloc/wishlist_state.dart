import 'package:equatable/equatable.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();
  @override
  List<Object?> get props => [];
}

class WishlistInitialState extends WishlistState {}

class WishlistLoadingState extends WishlistState {}

class WishlistSuccessState extends WishlistState {
  final List<dynamic> wishlist;

  const WishlistSuccessState({required this.wishlist});

  @override
  List<Object?> get props => [wishlist];
}

class WishlistActionSuccessState extends WishlistState {
  const WishlistActionSuccessState();
}

class WishlistActionRemovedState extends WishlistState {
  final int wishlistid;

  WishlistActionRemovedState({required this.wishlistid});
}

/// Wishlist item added to cart (dummy)
class WishlistAddedToCartState extends WishlistState {
  final int productId;

  const WishlistAddedToCartState(this.productId);

  @override
  List<Object?> get props => [productId];
}

class WishlistFailureState extends WishlistState {
  final String error;
  const WishlistFailureState(this.error);

  @override
  List<Object?> get props => [error];
}
