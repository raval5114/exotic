class DeliveryStatusStep {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final List<Map<String, String>>? subtasks;

  DeliveryStatusStep({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isCurrent = false,
    this.subtasks,
  });
}
