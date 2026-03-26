import 'package:flutter/material.dart';
import 'package:verleihapp/models/badge_model.dart';

/// Widget for displaying a single badge.
class BadgeWidget extends StatelessWidget {
  final BadgeModel badge;
  final double size;
  final bool showTooltip;

  const BadgeWidget({
    super.key,
    required this.badge,
    this.size = 32.0,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: badge.backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: badge.color.withValues(alpha: 0.3),
          width: 2.0,
        ),
      ),
      child: Icon(
        badge.icon,
        color: badge.color,
        size: size * 0.6,
      ),
    );

    if (showTooltip) {
      return Tooltip(
        message: '${badge.getTitle(context)}\n${badge.getDescription(context)}',
        preferBelow: false,
        child: widget,
      );
    }

    return widget;
  }
}