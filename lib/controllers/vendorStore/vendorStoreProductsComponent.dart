import 'package:exotic/controllers/vendorStore/src/itemTile.dart';
import 'package:exotic/data/blocs/vendorStore/bloc/vender_bloc.dart';
import 'package:exotic/data/models/product_orignal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class VendorStoreProductComponents extends StatefulWidget {
  const VendorStoreProductComponents({super.key});

  @override
  State<VendorStoreProductComponents> createState() =>
      _VendorStoreProductComponentsState();
}

class _VendorStoreProductComponentsState
    extends State<VendorStoreProductComponents> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<VenderBloc>().add(VenderStoreDataFetchingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VenderBloc, VenderState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is VenderLoadingState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6, // Number of shimmer tiles
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 12,
                                width: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 10,
                                width: 60,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 10,
                                width: 100,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 10,
                                width: 50,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        if (state is VendorStoreDataFetchedState) {
          List<Map<String, dynamic>> data = state.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder:
                  (BuildContext context, int index) => ItemTile(
                    product: ProductModel(),
                    imagepath: data[index]['imgages'][0],
                    itemName: data[index]['productName'],
                    discountedPrice: data[index]['discountedPrice'].toString(),
                    initialPrice: data[index]['initialPrice'].toString(),
                    discountedPercentage: data[index]['discount'].toString(),
                    ratings: data[index]['ratings'].toString(),
                    averageRatings: data[index]['ratings'],
                    bottomStatus:
                        data[index]['bottomStatus'] ?? "Free Delivery",
                  ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
