import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:exotic/data/providers/product_provider.dart';

class ProductVariantComponent extends StatelessWidget {
  final List<Variants> variants;

  const ProductVariantComponent({super.key, required this.variants});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final selectedIndex = productProvider.selectedIndex;

    if (variants.isEmpty) {
      return const SizedBox();
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Available Variants",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),

          /// ✅ ListView.builder
          SizedBox(
            height: 110,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: variants.length,
              itemBuilder: (context, index) {
                final variant = variants[index];
                final isSelected = selectedIndex == index;
                final isEnabled = variant.pvStatus == "1";

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap:
                        isEnabled
                            ? () {
                              /// 🔥 Update provider
                              productProvider.setVariantIndex(index);
                            }
                            : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 90,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected ? Colors.blue : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isEnabled ? Colors.white : Colors.grey.shade100,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              "https://xotic.in/UploadImages/Variant/${variant.pvMainImage}",
                              fit: BoxFit.contain,
                              color: isEnabled ? null : Colors.grey,
                              colorBlendMode:
                                  isEnabled ? null : BlendMode.saturation,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            variant.pvname,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                              color: isEnabled ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
