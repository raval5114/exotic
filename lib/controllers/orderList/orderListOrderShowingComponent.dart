import 'package:exotic/controllers/orderList/src/orderTile.dart';
import 'package:exotic/data/blocs/orderList/bloc/order_list_bloc.dart';
import 'package:exotic/data/providers/order_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrderListOrderShowingComponent extends StatefulWidget {
  const OrderListOrderShowingComponent({super.key});

  @override
  State<OrderListOrderShowingComponent> createState() =>
      _OrderListOrderShowingComponentState();
}

class _OrderListOrderShowingComponentState
    extends State<OrderListOrderShowingComponent> {
  // ── Brand colours ──────────────────────────────────────────────────────────
  static const Color _brandPrimary = Color(0xFF7C3AED);
  static const Color _brandPink    = Color(0xFFE94A75);
  static const Color _surface      = Color(0xFFF5F5FA);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: _surface,
        child: BlocConsumer<OrderListBloc, OrderListState>(
          listener: (context, state) {
            if (state is OrderShowningSuccessState) {
              context.read<OrderListProvider>().setOrders(state.data);
            }
          },
          builder: (context, state) {
            if (state is OrderShowingLoadingState) {
              return _buildShimmerLoader();
            }

            if (state is OrderShowningErrorState) {
              return _buildErrorState(context, state.errMsg);
            }

            return Consumer<OrderListProvider>(
              builder: (context, provider, _) {
                if (provider.orders.isEmpty) {
                  return state is OrderShowningSuccessState
                      ? _buildEmptyState(context)
                      : _buildShimmerLoader();
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 6, bottom: 24),
                  itemCount: provider.orders.length + 1, // +1 for header
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildListHeader(provider.orders.length);
                    }
                    return OrderShowingTile(
                      product: provider.orders[index - 1],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ── List header ─────────────────────────────────────────────────────────────
  Widget _buildListHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          const Text(
            'My Orders',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: _brandPrimary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _brandPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shimmer loader ─────────────────────────────────────────────────────────
  Widget _buildShimmerLoader() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.only(top: 14, bottom: 24),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFF9FAFB),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // accent stripe placeholder
                  Container(width: 4, color: Colors.white),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row placeholder
                          Row(
                            children: [
                              _shimmerBox(width: 72, height: 22, radius: 20),
                              const SizedBox(width: 8),
                              _shimmerBox(width: 80, height: 11),
                              const Spacer(),
                              _shimmerBox(width: 55, height: 11),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Middle row placeholder
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _shimmerBox(width: 72, height: 72, radius: 10),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _shimmerBox(width: double.infinity, height: 14),
                                    const SizedBox(height: 6),
                                    _shimmerBox(width: 160, height: 14),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _shimmerBox(width: 60, height: 16),
                                        const SizedBox(width: 8),
                                        _shimmerBox(width: 44, height: 20, radius: 6),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _shimmerBox(width: double.infinity, height: 1),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _shimmerBox(width: 100, height: 14),
                              _shimmerBox(width: 70, height: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _brandPrimary.withValues(alpha: 0.10),
                    _brandPrimary.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: _brandPrimary,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No Orders Yet',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "You haven't placed any orders yet.\nExplore our catalog and find something exotic!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            _PrimaryButton(
              label: 'Refresh Orders',
              icon: Icons.refresh_rounded,
              color: _brandPrimary,
              onPressed: () =>
                  context.read<OrderListBloc>().add(OrderListEvent()),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────
  Widget _buildErrorState(BuildContext context, String errMsg) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _brandPink.withValues(alpha: 0.12),
                    _brandPink.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 52,
                color: _brandPink,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Unable to Load Orders',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              errMsg.isNotEmpty
                  ? errMsg
                  : 'Something went wrong while connecting to the server. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            _PrimaryButton(
              label: 'Try Again',
              icon: Icons.refresh_rounded,
              color: _brandPrimary,
              onPressed: () =>
                  context.read<OrderListBloc>().add(OrderListEvent()),
            ),
            const SizedBox(height: 14),
            // Secondary contact hint
            Text(
              'If the problem persists, contact support.',
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 11,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PrimaryButton — reusable branded CTA button
// ─────────────────────────────────────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
