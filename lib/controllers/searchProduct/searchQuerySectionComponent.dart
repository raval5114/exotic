import 'package:exotic/controllers/products/productShellController.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Searchquerysectioncomponent extends StatefulWidget {
  const Searchquerysectioncomponent({super.key});

  @override
  State<Searchquerysectioncomponent> createState() =>
      _SearchquerysectioncomponentState();
}

class _SearchquerysectioncomponentState
    extends State<Searchquerysectioncomponent> {
  final TextEditingController controller = TextEditingController();
  final BoxController boxController = BoxController();

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 6,
  );

  static const double _borderRadius = 30;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: FieldSuggestion<Map<String, dynamic>>.network(
        textController: controller,
        boxController: boxController,
        inputDecoration: InputDecoration(
          hintText: 'Search product',
          border: InputBorder.none,
          isDense: true,
          hintStyle: GoogleFonts.roboto(
            fontSize: width * 0.035,
            color: Colors.grey.shade700,
          ),
        ),
        future: (input) async {
          if (input.isEmpty) return <Map<String, dynamic>>[];

          context.read<SearchProductBloc>().add(
            SearchProductSearchingEvent(query: input),
          );

          final state = await context
              .read<SearchProductBloc>()
              .stream
              .firstWhere(
                (state) =>
                    state is SearchProductQueryResultState ||
                    state is SearchErrorState,
              );

          if (state is SearchProductQueryResultState) {
            return state.queryResult;
          }

          return <Map<String, dynamic>>[];
        },
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final products = snapshot.data!;

          if (products.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "No products found",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            itemCount: products.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),

                /// 📝 Product name
                title: Text(
                  product['name'] ?? 'Unknown product',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                trailing: const Icon(
                  Icons.north_west,
                  size: 16,
                  color: Colors.grey,
                ),

                onTap: () {
                  // controller.text = product['name'];
                  boxController.close?.call();
                  context.read<FetchProductBloc>().add(
                    FetchingSingleProductEvent(productid: product['id']),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsShell()),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
