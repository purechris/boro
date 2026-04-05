import 'package:flutter/material.dart';
import 'package:verleihapp/services/app_settings_service.dart';

/// Displays a dismissible news banner loaded from the `app_settings` table.
/// Renders nothing when no banner text is configured for the current locale.
class NewsBannerWidget extends StatefulWidget {
  const NewsBannerWidget({super.key});

  @override
  State<NewsBannerWidget> createState() => _NewsBannerWidgetState();
}

class _NewsBannerWidgetState extends State<NewsBannerWidget> {
  final AppSettingsService _settingsService = AppSettingsService();

  String? _bannerText;
  bool _isDismissed = false;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      _loadBanner();
    }
  }

  Future<void> _loadBanner() async {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final String? text = await _settingsService.fetchNewsBannerText(languageCode);
    if (mounted) {
      setState(() => _bannerText = text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissed || _bannerText == null) return const SizedBox.shrink();
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.campaign_outlined, color: colors.onPrimaryContainer, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _bannerText!,
              style: TextStyle(
                fontSize: 14,
                color: colors.onPrimaryContainer,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isDismissed = true),
            child: Icon(Icons.close, size: 18, color: colors.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}
