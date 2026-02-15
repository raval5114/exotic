import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

/// 📥 Fetch wishlist
class FetchWishlistEvent extends WishlistEvent {
  final int cid;

  const FetchWishlistEvent(this.cid);

  @override
  List<Object?> get props => [cid];
}

/// ➕ Add to wishlist
class AddWishlistEvent extends WishlistEvent {
  final int cid;
  final int pid;

  const AddWishlistEvent({required this.cid, required this.pid});

  @override
  List<Object?> get props => [cid, pid];
}

/// ❌ Remove from wishlist
class RemoveWishlistEvent extends WishlistEvent {
  final int wishlistid;
  const RemoveWishlistEvent({required this.wishlistid});

  @override
  List<Object?> get props => [wishlistid];
}

/// 🛒 ADD TO CART (from wishlist)
class AddWishlistItemToCartEvent extends WishlistEvent {
  final int productId;
  final int? variantId;
  final int? customerId;
  const AddWishlistItemToCartEvent({
    required this.productId,
    this.variantId,
    this.customerId,
  });

  @override
  List<Object?> get props => [productId, variantId];
}
