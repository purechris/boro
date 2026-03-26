import 'package:flutter/material.dart';

class NavigationUtils {
  static Future<void> navigateTo(BuildContext context, Widget page, {
    bool clearStack = false,
  }) async {
    if (clearStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  /// Navigate back to the previous page.
  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void navigateToAndClearStack(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false,
    );
  }

  static void navigateToReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
} 