import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Image picker component for the post lendable page.
class PostImagePicker extends StatelessWidget {
  final XFile? selectedImage;
  final String? imageUrl;
  final VoidCallback onPickImage;
  final VoidCallback onClearImage;

  const PostImagePicker({
    super.key,
    this.selectedImage,
    this.imageUrl,
    required this.onPickImage,
    required this.onClearImage,
  });

  static const double _imageHeight = 250.0;
  static const double _iconSize = 50.0;
  static const double _closeIconSize = 25.0;
  static const double _closeButtonRadius = 16.0;
  static const double _verticalPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: Stack(
        children: [
          Container(
            height: _imageHeight,
            width: double.infinity,
            color: Colors.grey[300],
            child: selectedImage == null
                ? (imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(imageUrl!, fit: BoxFit.contain)
                    : Icon(Icons.add_a_photo, size: _iconSize, color: Colors.grey[700]))
                : FutureBuilder<Uint8List>(
                    future: selectedImage!.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.contain,
                        );
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error, size: _iconSize, color: Colors.red);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
          if (selectedImage != null || (imageUrl != null && imageUrl!.isNotEmpty))
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                minimum: const EdgeInsets.all(_verticalPadding),
                child: GestureDetector(
                  onTap: onClearImage,
                  child: CircleAvatar(
                    radius: _closeButtonRadius,
                    backgroundColor: Colors.grey[800],
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: _closeIconSize,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
