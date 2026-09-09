import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A widget that loads images only when they are visible in the viewport.
/// This significantly reduces unnecessary Supabase storage calls.
class LazyImageWidget extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget placeholder;

  const LazyImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    required this.placeholder,
  });

  @override
  State<LazyImageWidget> createState() => _LazyImageWidgetState();
}

class _LazyImageWidgetState extends State<LazyImageWidget> {
  static const int _maxCacheDimension = 500;

  bool _shouldLoad = false;
  bool _hasBeenVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('lazy_image_${widget.imageUrl}'),
      onVisibilityChanged: (VisibilityInfo info) {
        // Lade Bild, wenn es zu mindestens 10% sichtbar ist
        if (info.visibleFraction > 0.1 && !_hasBeenVisible) {
          _hasBeenVisible = true;
          if (mounted) {
            setState(() {
              _shouldLoad = true;
            });
          }
        }
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _shouldLoad
            ? CachedNetworkImage(
                imageUrl: widget.imageUrl,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                placeholder: (context, url) => widget.placeholder,
                errorWidget: (context, url, error) => widget.placeholder,
                // Cache configuration
                cacheKey: widget.imageUrl,
                maxWidthDiskCache: _maxCacheDimension,
                maxHeightDiskCache: _maxCacheDimension,
                memCacheWidth: _maxCacheDimension,
                fadeInDuration: const Duration(milliseconds: 200),
              )
            : widget.placeholder,
      ),
    );
  }
}

