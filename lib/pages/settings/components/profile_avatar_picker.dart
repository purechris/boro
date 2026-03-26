import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Avatar picker component for the edit profile page.
class ProfileAvatarPicker extends StatelessWidget {
  final XFile? selectedImage;
  final String? imageUrl;
  final VoidCallback onPickImage;
  final VoidCallback onClearImage;

  const ProfileAvatarPicker({
    super.key,
    this.selectedImage,
    this.imageUrl,
    required this.onPickImage,
    required this.onClearImage,
  });

  static const _imageSize = 150.0;
  static const _iconSize = 50.0;
  static const _closeButtonRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: Stack(
          children: [
            Container(
              height: _imageSize,
              width: _imageSize,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: selectedImage == null
                  ? (imageUrl != null && imageUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            width: _imageSize,
                            height: _imageSize,
                          ),
                        )
                      : Icon(Icons.add_a_photo, size: _iconSize, color: Colors.grey[700]))
                  : FutureBuilder<Uint8List>(
                      future: selectedImage!.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ClipOval(
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: _imageSize,
                              height: _imageSize,
                            ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: onClearImage,
                      child: CircleAvatar(
                        radius: _closeButtonRadius,
                        backgroundColor: Colors.grey[800],
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
