import 'package:flutter/material.dart';
import 'package:verleihapp/utils/url_launcher_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class SupportDeveloperPage extends StatelessWidget {
  const SupportDeveloperPage({super.key});

  static const _coffeeUrl = 'https://www.paypal.me/ChristianBegert';
  static const _padding = 16.0;
  static const _spacing = 8.0;

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
            ElevatedButton.icon(
              onPressed: () => UrlLauncherUtils.launchUrl(
                _coffeeUrl,
                context: context,
              ),
              icon: const Icon(Icons.coffee),
              label: Text(AppLocalizations.of(context)!.paypalDonateLink),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: _padding * 2,
                  vertical: _spacing,
                ),
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