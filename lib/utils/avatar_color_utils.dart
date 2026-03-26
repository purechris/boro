import 'package:flutter/material.dart';
import 'package:verleihapp/components/cached_avatar_widget.dart';

/// Utility class for consistent avatar colors based on name.
class AvatarColorUtils {
  /// List of available avatar colors.
  static const List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.brown,
    Colors.blueGrey,
  ];

  /// Get a color based on the first letter of a name.
  ///
  /// [name] The user's name
  /// Returns a consistent color for the given name
  static Color getAvatarColor(String name) {
    if (name.isEmpty) return Colors.grey;
    
    final firstLetter = name[0].toUpperCase();
    final colorIndex = firstLetter.codeUnitAt(0) % _colors.length;
    return _colors[colorIndex];
  }

  /// Create a CircleAvatar with consistent coloring.
  /// Now uses CachedNetworkImage for better performance.
  ///
  /// [name] The user's name
  /// [imageUrl] Optional: Profile image URL
  /// [radius] Avatar radius (default: 24.0)
  /// [iconSize] Icon size (default: 24.0)
  static Widget createAvatar({
    required String name,
    String? imageUrl,
    double radius = 24.0,
    double iconSize = 24.0,
  }) {
    return CachedAvatarWidget(
      name: name,
      imageUrl: imageUrl,
      radius: radius,
      iconSize: iconSize,
    );
  }
}
