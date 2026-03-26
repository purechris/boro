import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:verleihapp/utils/avatar_color_utils.dart';

/// A widget for cached profile images (avatars) with fallback to colored avatar.
/// Uses CachedNetworkImage for optimal performance and reduces storage calls.
class CachedAvatarWidget extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;
  final double iconSize;

  const CachedAvatarWidget({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 24.0,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    // If no imageUrl provided, show colored avatar
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AvatarColorUtils.getAvatarColor(name),
        child: Icon(
          Icons.person,
          size: iconSize,
          color: Colors.white,
        ),
      );
    }

    // Calculate cache size based on radius (2 * radius for diameter)
    // Multiply by device pixel ratio for sharpness on high-DPI displays
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final int cacheSize = (radius * 2 * devicePixelRatio).round();
    
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircleAvatar(
          radius: radius,
          backgroundColor: AvatarColorUtils.getAvatarColor(name),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: radius,
          backgroundColor: AvatarColorUtils.getAvatarColor(name),
          child: Icon(
            Icons.person,
            size: iconSize,
            color: Colors.white,
          ),
        ),
        // Cache configuration for optimal performance
        cacheKey: imageUrl,
        // MemCache: Optimized for avatar size including pixel density
        memCacheWidth: cacheSize,
        memCacheHeight: cacheSize,
        // Konsistente Animation für alle Bilder (auch aus Cache)
        fadeInDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}

