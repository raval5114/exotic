import 'package:exotic/controllers/products/productShellController.dart';
import 'package:exotic/controllers/src/appbar.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleProductCallingTesting extends StatelessWidget {
  const SingleProductCallingTesting({super.key});

  @override
  Widget build(BuildContext context) {
    void onTap() {
      print('working');
      context.read<FetchProductBloc>().add(
        FetchingSingleProductEvent(productid: "57"),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductsShell()),
      );
    }

    return Scaffold(
      appBar: ExoticAppBar(),
      body: Center(
        child: ElevatedButton(onPressed: onTap, child: Text("Click Me")),
      ),
    );
  }
}
