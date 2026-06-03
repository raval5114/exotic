import 'dart:convert';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:flutter/material.dart';

class ProductDetailsComponent extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onViewAllDetails;

  const ProductDetailsComponent({
    super.key,
    required this.product,
    this.onViewAllDetails,
  });

  @override
  State<ProductDetailsComponent> createState() =>
      _ProductDetailsComponentState();
}

class _ProductDetailsComponentState extends State<ProductDetailsComponent> {
  bool _highlightsExpanded = true;
  bool _allDetailsExpanded = false;

  /// Converts: {"fabric":["Georgette"],"color":["Red"]}
  /// → [{key: Fabric, value: Georgette}, {key: Color, value: Red}]
  List<Map<String, dynamic>> getProductDetails(String raw) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      final List<Map<String, dynamic>> result = [];

      decoded.forEach((key, value) {
        final label = key
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}',
            )
            .join(' ');

        if (value is List) {
          for (final item in value) {
            result.add({'key': label, 'value': item.toString()});
          }
        } else {
          result.add({'key': label, 'value': value.toString()});
        }
      });

      return result;
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final productDetails = getProductDetails(widget.product.pDetail ?? '{}');

    // Show max 4 entries (2 rows × 2 cols) in highlights; rest go to "All details"
    final highlights = productDetails.take(4).toList();
    final allDetails = productDetails;

    final description = widget.product.pDesc ?? '';
    final shortDesc = widget.product.pShortDesc ?? '';

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Product Highlights ───────────────────────────────────────
          InkWell(
            onTap:
                () =>
                    setState(() => _highlightsExpanded = !_highlightsExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Product highlights',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111111),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _highlightsExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_highlightsExpanded) ...[
            if (highlights.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'No highlights available.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontFamily: 'Roboto',
                  ),
                ),
              )
            else
              _buildHighlightsGrid(highlights),
          ],

          const Divider(height: 1, thickness: 0.8, color: Color(0xFFEAEAEA)),

          // ─── All Details ──────────────────────────────────────────────
          InkWell(
            onTap: () {
              setState(() => _allDetailsExpanded = !_allDetailsExpanded);
              if (widget.onViewAllDetails != null) widget.onViewAllDetails!();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'All details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111111),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Features, description and more',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade500,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _allDetailsExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_allDetailsExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (shortDesc.isNotEmpty) ...[
                    Text(
                      shortDesc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF444444),
                        fontFamily: 'Roboto',
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Full attribute list
                  ...allDetails.map((detail) => _buildDetailRow(detail)),

                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF555555),
                        fontFamily: 'Roboto',
                        height: 1.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildHighlightsGrid(List<Map<String, dynamic>> items) {
    // Build rows of 2 columns
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildHighlightCell(left)),
              if (right != null) ...[
                const SizedBox(width: 16),
                Expanded(child: _buildHighlightCell(right)),
              ] else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );

      // Divider between rows (not after last)
      if (i + 2 < items.length) {
        rows.add(
          const Divider(
            height: 1,
            thickness: 0.6,
            color: Color(0xFFEAEAEA),
            indent: 16,
            endIndent: 16,
          ),
        );
      }
    }

    return Column(
      children: [
        const SizedBox(height: 4),
        ...rows,
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildHighlightCell(Map<String, dynamic> detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail['key'],
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey.shade500,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            detail['value'],
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF111111),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(Map<String, dynamic> detail) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  detail['key'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  detail['value'],
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF222222),
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 0.6, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
