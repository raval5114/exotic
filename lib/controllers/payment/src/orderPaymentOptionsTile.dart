import 'package:flutter/material.dart';

class OrderPaymentOptionsTileExpandable extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? expandedChild;
  final bool enabled;

  const OrderPaymentOptionsTileExpandable({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.expandedChild,
    this.enabled = true,
  });

  @override
  State<OrderPaymentOptionsTileExpandable> createState() =>
      _OrderPaymentOptionsTileExpandableState();
}

class _OrderPaymentOptionsTileExpandableState
    extends State<OrderPaymentOptionsTileExpandable> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final Color textColor = widget.enabled ? Colors.black : Colors.grey;
    final Color subtitleColor =
        widget.enabled ? Colors.grey[700]! : Colors.grey;

    return Column(
      children: [
        ListTile(
          enabled: widget.enabled,
          onTap: () {
            if (widget.enabled) {
              setState(() {
                isExpanded = !isExpanded;
              });
            }
          },
          leading: widget.leading,
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
          ),
          subtitle:
              widget.subtitle != null
                  ? Text(
                    widget.subtitle!,
                    style: TextStyle(fontSize: 13, color: subtitleColor),
                  )
                  : null,
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: widget.enabled ? Colors.black : Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
        if (isExpanded && widget.expandedChild != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: widget.expandedChild!,
          ),
      ],
    );
  }
}
