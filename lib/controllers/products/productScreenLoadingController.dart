import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductScreenLoadingController extends StatelessWidget {
  const ProductScreenLoadingController({super.key});

  static final Color _bgColor = Colors.grey.shade100;
  static final Color _skeletonColor = Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade200,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_imageSection(), _contentSection(), _buttonSection()],
          ),
        ),
      ),
    );
  }

  Widget _imageSection() {
    return Container(
      height: 320,
      width: double.infinity,
      color: _skeletonColor,
    );
  }

  Widget _contentSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _line(height: 18),
          const SizedBox(height: 8),
          _line(height: 18, width: 220),

          const SizedBox(height: 12),
          Row(
            children: [
              _line(height: 22, width: 90),
              const SizedBox(width: 12),
              _line(height: 16, width: 60),
            ],
          ),

          const SizedBox(height: 16),
          _line(height: 16, width: 120),

          const SizedBox(height: 22),
          _sectionTitle(),
          _offerLine(),
          _offerLine(),
          _offerLine(),

          const SizedBox(height: 22),
          _sectionTitle(),
          _line(height: 14, width: 180),
          const SizedBox(height: 8),
          _line(height: 14, width: 140),
        ],
      ),
    );
  }

  Widget _buttonSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        children: [
          Expanded(child: _button()),
          const SizedBox(width: 12),
          Expanded(child: _button()),
        ],
      ),
    );
  }

  Widget _line({double height = 14, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: _skeletonColor,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _sectionTitle() {
    return Container(
      height: 16,
      width: 140,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _skeletonColor,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _offerLine() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _line(height: 14),
    );
  }

  Widget _button() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _skeletonColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
