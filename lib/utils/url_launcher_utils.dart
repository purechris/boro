import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class UrlLauncherUtils {
  /// Open a URL in the platform's default browser.
  ///
  /// [url] The URL to open as a string
  /// [context] Optional BuildContext for error handling with snackbar
  /// [mode] LaunchMode - default is platformDefault for maximum compatibility
  ///
  /// Throws an Exception if [context] is null and the URL cannot be opened.
  /// Shows an error message via snackbar if [context] is provided.
  static Future<void> launchUrl(
    String url, {
    BuildContext? context,
    launcher.LaunchMode mode = launcher.LaunchMode.platformDefault,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await launcher.canLaunchUrl(uri)) {
        await launcher.launchUrl(uri, mode: mode);
      } else {
        if (context == null) {
          throw Exception('Could not launch $url');
        }
        if (!context.mounted) return;
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.linkCouldNotOpen(url));
      }
    } catch (e) {
      if (context == null) {
        throw Exception('Could not launch $url: $e');
      }
      if (!context.mounted) return;
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.linkCouldNotOpen(url));
    }
  }
}

