import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SizeSelector extends StatefulWidget {
  final Map<String, dynamic> productData;

  const SizeSelector({super.key, required this.productData});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String? selectedSize;
  final List<String> allSizes = ["S", "M", "L", "XL"];

  @override
  Widget build(BuildContext context) {
    final List<String> availableSizes = List<String>.from(
      widget.productData["sizeChart"] ?? [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Size',
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            // Size Chart link
            GestureDetector(
              onTap: () {
                // Show size chart modal or navigate
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text("Size Chart"),
                        content: const Text(
                          "This is where you'd show your chart.",
                        ),
                      ),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.bar_chart, color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "Size Chart",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            // Size buttons
            Row(
              children:
                  allSizes.map((size) {
                    final bool isAvailable = availableSizes.contains(size);
                    final bool isSelected = selectedSize == size;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap:
                            isAvailable
                                ? () => setState(() => selectedSize = size)
                                : null,
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isAvailable
                                      ? Colors.black
                                      : Colors.grey.withOpacity(0.5),
                            ),
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              color:
                                  isAvailable
                                      ? (isSelected
                                          ? Colors.white
                                          : Colors.black)
                                      : Colors.grey,
                              decoration:
                                  isAvailable
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
