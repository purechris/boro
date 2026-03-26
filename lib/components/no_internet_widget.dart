import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool fullScreen;

  const NoInternetWidget({
    super.key,
    this.onRetry,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.signal_wifi_off_rounded,
                size: 64,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)?.noInternetConnection ?? 'No internet connection',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)?.retry ?? 'Try again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (fullScreen) {
      return Scaffold(
        body: SafeArea(child: content),
      );
    }

    return content;
  }
}
