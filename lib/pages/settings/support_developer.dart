import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verleihapp/utils/url_launcher_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class SupportDeveloperPage extends StatelessWidget {
  const SupportDeveloperPage({super.key});

  static const _coffeeUrl = 'https://www.paypal.me/ChristianBegert';
  static const _padding = 16.0;
  static const _spacing = 8.0;

  Future<void> _copyDonationLinkToClipboard(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(const ClipboardData(text: _coffeeUrl));
    if (!context.mounted) return;
    SnackbarUtils.showSuccess(context, l10n.linkCopiedToClipboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.supportDeveloper),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              AppLocalizations.of(context)!.supportDeveloperText,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: _spacing * 3),
            InkWell(
              onTap: () => UrlLauncherUtils.launchUrl(
                _coffeeUrl,
                context: context,
              ),
              onLongPress: () => _copyDonationLinkToClipboard(context),
              child: Text(
                _coffeeUrl,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: _spacing),
            Text(
              AppLocalizations.of(context)!.paypalDonateLinkHint,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: _spacing * 3),
            Text(
              AppLocalizations.of(context)!.thanksForSupport,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}