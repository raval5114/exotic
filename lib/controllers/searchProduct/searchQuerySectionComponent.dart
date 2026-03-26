import 'package:exotic/controllers/products/productShellController.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_bloc.dart';
import 'package:exotic/data/blocs/products/bloc/fetch_products_event.dart';
import 'package:exotic/data/blocs/searchProduct/bloc/search_product_bloc.dart';
import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return FieldSuggestion<Map<String, dynamic>>.network(
      textController: controller,
      boxController: boxController,
      inputDecoration: InputDecoration(
        hintText: 'Search for products, brands...',
        hintStyle: TextStyle(
          fontSize: width * 0.035,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w500,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ), // Centering text vertically
        suffixIcon:
            controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black38,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.clear();
                    });
                    boxController.close?.call();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                )
                : null,
      ),
      future: (input) async {
        if (input.isEmpty) return <Map<String, dynamic>>[];

        context.read<SearchProductBloc>().add(
          SearchProductSearchingEvent(query: input),
        );

        final state = await context.read<SearchProductBloc>().stream.firstWhere(
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
          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: const SizedBox(
              height: 60,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFFFF528A), // vibrant pink accent
                  ),
                ),
              ),
            ),
          );
        }

        final products = snapshot.data!;

        if (products.isEmpty) {
          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.search_off, color: Colors.grey.shade400),
                  const SizedBox(width: 8),
                  Text(
                    "No products found",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: products.length,
            separatorBuilder:
                (_, __) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade100,
                ),
            itemBuilder: (context, index) {
              final product = products[index];

              return InkWell(
                onTap: () {
                  boxController.close?.call();
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<FetchProductBloc>().add(
                    FetchingSingleProductEvent(productid: product['id']),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsShell()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical:
                        12, // Reduced padding to ensure column text fits perfectly without explicit bounding breaks
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child:
                            product['image'] != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product['image'],
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => const Icon(
                                          Icons.inventory_2_outlined,
                                          color: Colors.black38,
                                          size: 20,
                                        ),
                                  ),
                                )
                                : const Icon(
                                  Icons.search,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product['name'] ?? 'Unknown product',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            if (product['category'] != null ||
                                product['price'] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                product['category'] ?? "Product",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        Icons.call_made,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
