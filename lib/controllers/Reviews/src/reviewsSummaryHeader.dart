import 'package:flutter/material.dart';

class ReviewSummaryHeader extends StatelessWidget {
  final dynamic summary;
  const ReviewSummaryHeader({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildPill("Overall", true),
              const SizedBox(width: 8),
              _buildPill("Camera", false),
              const SizedBox(width: 8),
              _buildPill("Battery", false),
              const SizedBox(width: 8),
              _buildPill("Performance", false),
              const SizedBox(width: 8),
              _buildPill("Display", false),
            ],
          ),
        ),
        Container(height: 8, color: Colors.grey[200]),

        // Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              // Left
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        double rating =
                            double.tryParse(summary.averageRating.toString()) ??
                            5.0;
                        return Icon(
                          Icons.star,
                          color:
                              i < rating.round()
                                  ? Colors.green[700]
                                  : Colors.grey[300],
                          size: 24,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "42,391 ratings and\n${summary.totalReviews} reviews",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(width: 1, height: 70, color: Colors.grey[300]),
              const SizedBox(width: 16),
              // Right
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildProgressBar(
                      5,
                      summary.rating5Count ?? 29863,
                      Colors.green[700]!,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(
                      4,
                      summary.rating4Count ?? 7906,
                      Colors.green[600]!,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(
                      3,
                      summary.rating3Count ?? 1949,
                      Colors.green[400]!,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(
                      2,
                      summary.rating2Count ?? 736,
                      Colors.lightGreen,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(
                      1,
                      summary.rating1Count ?? 1937,
                      Colors.red[400]!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Horizontal Image Scroller
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.grey.shade200,
                  child: Image.network(
                    "https://picsum.photos/seed/header$idx/200",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (ctx, _, __) => const SizedBox(
                          width: 100,
                          height: 100,
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Container(height: 8, color: Colors.grey[200]),

        // Sorting tabs
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "User reviews sorted by",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildPill("Most Helpful", true),
              const SizedBox(width: 8),
              _buildPill("Latest", false),
              const SizedBox(width: 8),
              _buildPill("Positive", false),
              const SizedBox(width: 8),
              _buildPill("Negative", false),
            ],
          ),
        ),
        Divider(thickness: 1, height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  Widget _buildPill(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProgressBar(int stars, int count, Color color) {
    return Row(
      children: [
        Text(
          "$stars \u2605",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count == 0 ? 0 : (count / 30000.0).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            count.toString(),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
