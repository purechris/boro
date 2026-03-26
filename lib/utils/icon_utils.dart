import 'package:flutter/material.dart';

class IconUtils {
  static const List<IconData> availableIcons = [
    Icons.groups,
    Icons.home,
    Icons.family_restroom,
    Icons.work,
    Icons.build,
    Icons.celebration,
    Icons.hiking,
    Icons.sports_soccer,
    Icons.directions_bike,
    Icons.restaurant,
    Icons.camera_alt,
    Icons.handshake,
    Icons.yard,
  ];

  static IconData getIconData(String? iconCode) {
    if (iconCode == null) return Icons.groups;
    
    try {
      return availableIcons.firstWhere(
        (icon) => icon.codePoint.toString() == iconCode,
        orElse: () => Icons.groups,
      );
    } catch (e) {
      return Icons.groups;
    }
  }
}
