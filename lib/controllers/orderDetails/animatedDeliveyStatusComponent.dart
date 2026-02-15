import 'package:exotic/controllers/orderDetails/src/deliveyStatusStep.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedDeliveryTimeline extends StatelessWidget {
  final List<DeliveryStatusStep> steps;
  final int? visibleStepCount;

  const AnimatedDeliveryTimeline({
    super.key,
    required this.steps,
    this.visibleStepCount,
  });

  @override
  Widget build(BuildContext context) {
    final displaySteps =
        visibleStepCount != null
            ? steps.take(visibleStepCount!).toList()
            : steps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displaySteps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == displaySteps.length - 1;

          return AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bullet + Vertical Line
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(top: 4),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color:
                            step.isCurrent
                                ? Colors.green
                                : step.isCompleted
                                ? Colors.grey
                                : Colors.white,
                        border: Border.all(
                          color:
                              step.isCurrent || step.isCompleted
                                  ? Colors.green
                                  : Colors.grey,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.grey.shade300,
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Step Texts
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding:
                        step.isCurrent
                            ? const EdgeInsets.all(8)
                            : EdgeInsets.zero,
                    decoration:
                        step.isCurrent
                            ? BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            )
                            : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color:
                                step.isCurrent ? Colors.green : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step.subtitle,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        if (step.subtasks != null && step.subtasks!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  step.subtasks!.map((sub) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        "${sub['status']} ${sub['timestamp'] != null ? "\n${_formatDateTime(sub['timestamp'])}" : ""}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  String _formatDateTime(String? raw) {
    if (raw == null) return "";
    try {
      final dt = DateTime.parse(raw);
      return "${_formatWeekday(dt)}, ${_formatTime(dt)}";
    } catch (_) {
      return "";
    }
  }

  String _formatWeekday(DateTime dt) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return "${days[dt.weekday % 7]}, ${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} '${dt.year % 100}";
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "$hour:${dt.minute.toString().padLeft(2, '0')} $ampm";
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}
