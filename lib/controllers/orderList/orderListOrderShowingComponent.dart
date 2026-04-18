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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: BlocConsumer<OrderListBloc, OrderListState>(
          listener: (context, state) {
            if (state is OrderShowningSuccessState) {
              context.read<OrderListProvider>().setOrders(state.data);
            }
          },
          builder: (context, state) {
            if (state is OrderShowingLoadingState) {
              return ListView.builder(
                itemCount: 6,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemBuilder:
                    (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 12,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 10,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              );
            }

            if (state is OrderShowningErrorState) {
              return Center(child: Text(state.errMsg));
            }

            // By default use provider so that any local changes on provider reflects without bloc emitting
            return Consumer<OrderListProvider>(
              builder: (context, provider, child) {
                if (provider.orders.isEmpty && state is! OrderShowningSuccessState) {
                  return const SizedBox();
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: provider.orders.length,
                  itemBuilder: (context, index) {
                    return OrderShowingTile(product: provider.orders[index]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
