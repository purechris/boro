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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.campaign_outlined, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _bannerText!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isDismissed = true),
            child: Icon(Icons.close, size: 18, color: Colors.green.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}
