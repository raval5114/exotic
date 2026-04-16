import 'package:flutter/material.dart';

class AnimatedActionPill extends StatefulWidget {
  final IconData defaultIcon;
  final IconData activeIcon;
  final String text;

  const AnimatedActionPill({
    super.key,
    required this.defaultIcon,
    required this.activeIcon,
    required this.text,
  });

  @override
  State<AnimatedActionPill> createState() => _AnimatedActionPillState();
}

class _AnimatedActionPillState extends State<AnimatedActionPill> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isActive ? Colors.blue : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isActive ? widget.activeIcon : widget.defaultIcon,
                key: ValueKey<bool>(isActive),
                size: 16,
                color: isActive ? Colors.blue : Colors.black54,
              ),
            ),
            if (widget.text.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                widget.text,
                style: TextStyle(
                  color: isActive ? Colors.blue : Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
