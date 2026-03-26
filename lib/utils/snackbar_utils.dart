import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackBar(BuildContext context, String message, {
    Color? backgroundColor,
    Duration? duration,
    SnackBarBehavior? behavior,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.grey,
        duration: duration ?? const Duration(seconds: 4),
        behavior: behavior ?? SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfo(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.grey,
      duration: const Duration(seconds: 2),
    );
  }
} 