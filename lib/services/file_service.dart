import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/main.dart';

import 'package:verleihapp/models/file_upload_dto.dart';

/// Service for managing file uploads and storage in the lending app.
class FileService {
  static const String _noUserLoggedInError = 'No user logged in';
  static const String _missingIdsError = 'User ID and Lendable ID are required';
  static const String _imageDecodeError = 'Error decoding image';
  static const String _compressError = 'Error compressing image';
  static const String _uploadError = 'Error uploading image';
  static const String _deleteError = 'Error deleting images';
  static const String _fileTooLargeError = 'The file is too large. Maximum size: 15MB';
  static const int _maxFileSize = 15 * 1024 * 1024; // 15MB in bytes

  final SupabaseClient _supabase = Supabase.instance.client;

  String get _currentUserId {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception(_noUserLoggedInError);
    }
    return userId;
  }

  /// Check file size to ensure it doesn't exceed maximum.
  Future<void> _checkFileSize(XFile file) async {
    final bytes = await file.readAsBytes();
    if (bytes.length > _maxFileSize) {
      throw Exception(_fileTooLargeError);
    }
  }

  /// Compress an image to specified width.
  Future<Uint8List> _compressImage(XFile image, {required int width}) async {
    try {
      final bytes = await image.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        throw Exception(_imageDecodeError);
      }

      final compressedImage = img.copyResize(originalImage, width: width);
      return Uint8List.fromList(img.encodeJpg(compressedImage, quality: 85));
    } catch (e) {
      throw Exception('$_compressError: $e');
    }
  }

  /// Upload a file.
  Future<FileUploadResult> _uploadFile(
    XFile file,
    String bucket,
    String path, {
    required String prefix,
    required int width,
  }) async {
    try {
      // Check file size first
      await _checkFileSize(file);

      final compressedBytes = await _compressImage(file, width: width);
      final uniqueFileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final fullPath = '$path/$uniqueFileName';
      
      await _supabase.storage
          .from(bucket)
          .uploadBinary(fullPath, compressedBytes, fileOptions: FileOptions(upsert: true));

      final publicUrl = _supabase.storage
          .from(bucket)
          .getPublicUrl(fullPath);

      return FileUploadResult(
        url: publicUrl,
        fileName: uniqueFileName,
      );
    } catch (e) {
      throw Exception('$_uploadError: $e');
    }
  }

  /// Upload an image for a lendable item.
  Future<FileUploadResult> uploadLendableImage(XFile image, String userId, String lendableId) async {
    if (userId.isEmpty || lendableId.isEmpty) {
      throw Exception(_missingIdsError);
    }
    return _uploadFile(
      image,
      'lendable.images',
      '$userId/$lendableId',
      prefix: 'lendable',
      width: 600,
    );
  }

  /// Upload a profile image.
  Future<String> uploadProfileImage(XFile image) async {
    final result = await _uploadFile(
      image,
      'profile.images',
      _currentUserId,
      prefix: 'profile',
      width: 200,
    );
    return result.url;
  }

  /// Delete files.
  Future<void> _deleteFiles(
    String bucket,
    String path, {
    String? fileName,
  }) async {
    try {
      if (fileName != null && fileName.isNotEmpty) {
        await _supabase.storage
            .from(bucket)
            .remove(['$path/$fileName']);
      } else {
        final files = await _supabase.storage
            .from(bucket)
            .list(path: path);

        if (files.isNotEmpty) {
          final fileNames = files.map((file) => '$path/${file.name}').toList();
          await _supabase.storage
              .from(bucket)
              .remove(fileNames);
        }
      }
    } catch (e) {
      throw Exception('$_deleteError: $e');
    }
  }

  /// Delete an image of a lendable item.
  Future<void> deleteLendableImage(String userId, String lendableId, {String? fileName}) async {
    await _deleteFiles(
      'lendable.images',
      '$userId/$lendableId',
      fileName: fileName,
    );
  }

  /// Delete a user's profile image.
  Future<void> deleteProfileImage(String userId) async {
    await _deleteFiles(
      'profile.images',
      userId,
    );
  }
}