import 'package:exotic/controllers/orderList/orderListOrderShowingComponent.dart';
import 'package:exotic/controllers/Homescreen/Categories/orderListSearchingComponent.dart';
import 'package:exotic/data/blocs/orderList/bloc/order_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListComponent extends StatefulWidget {
  const OrderListComponent({super.key});

  @override
  State<OrderListComponent> createState() => _OrderListComponentState();
}

class _OrderListComponentState extends State<OrderListComponent> {
  @override
  void initState() {
    super.initState();
    context.read<OrderListBloc>().add(OrderListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderListSearchingComponent(),
        OrderListOrderShowingComponent(),
      ],
    );
  }
}
