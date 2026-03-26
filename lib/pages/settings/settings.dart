import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:verleihapp/pages/settings/feedback.dart';
import 'package:verleihapp/pages/settings/support_developer.dart';
import 'package:verleihapp/pages/settings/language_settings.dart';
import 'package:verleihapp/pages/login/change_password.dart';
import 'package:verleihapp/pages/login/pre_login.dart';
import 'package:verleihapp/services/auth_service.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/utils/url_launcher_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        bottom: true, // Explizit unten berücksichtigen für transparente Navigationsleiste
        child: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.settings),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _buildAppSection(context),
              _buildLegalSection(context),
              _buildLogoutSection(context),
            ],
          ),
        ),
        _buildVersionInfo(context),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return _SettingsSection(
      title: AppLocalizations.of(context)!.app,
      children: [
        _SettingsTile(
          icon: Icons.feedback,
          title: AppLocalizations.of(context)!.feedback,
          onTap: () => NavigationUtils.navigateTo(context, const FeedbackPage()),
        ),
        _SettingsTile(
          icon: Icons.coffee,
          title: AppLocalizations.of(context)!.supportDeveloper,
          onTap: () => NavigationUtils.navigateTo(context, const SupportDeveloperPage()),
        ),
        _SettingsTile(
          icon: Icons.language,
          title: AppLocalizations.of(context)!.language,
          onTap: () => NavigationUtils.navigateTo(context, const LanguageSettingsPage()),
        ),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return _SettingsSection(
      title: AppLocalizations.of(context)!.legal,
      children: [
        _SettingsTile(
          icon: Icons.privacy_tip,
          title: AppLocalizations.of(context)!.privacyPolicy,
          trailingIcon: Icons.open_in_new,
          onTap: () => UrlLauncherUtils.launchUrl(
            'https://www.boro-app.de/datenschutz.html',
            context: context,
          ),
        ),
        _SettingsTile(
          icon: Icons.description,
          title: AppLocalizations.of(context)!.imprint,
          trailingIcon: Icons.open_in_new,
          onTap: () => UrlLauncherUtils.launchUrl(
            'https://www.boro-app.de/impressum.html',
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return _SettingsSection(
      title: AppLocalizations.of(context)!.account,
      children: [
        _SettingsTile(
          icon: Icons.lock,
          title: AppLocalizations.of(context)!.changePassword,
          onTap: () => NavigationUtils.navigateTo(
            context,
            const ChangePasswordPage(),
          ),
        ),
        _SettingsTile(
          icon: Icons.logout,
          title: AppLocalizations.of(context)!.logout,
          onTap: () async {
            try {
              await AuthService().signout();
              if (!context.mounted) return;
              await NavigationUtils.navigateTo(context, PreLogin(), clearStack: true);
            } catch (e) {
              if (!context.mounted) return;
              SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
            }
          },
        ),
      ],
    );
  }

  String _getPlatformAbbreviation(BuildContext context) {
    if (kIsWeb) {
      return AppLocalizations.of(context)!.web;
    }
    return AppLocalizations.of(context)!.android;
  }

  Widget _buildVersionInfo(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data!;
          final versionStr = '${packageInfo.version}+${packageInfo.buildNumber}';
          final platform = _getPlatformAbbreviation(context);
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.version(versionStr, platform),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final IconData? trailingIcon;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(trailingIcon ?? Icons.chevron_right),
      onTap: onTap,
    );
  }
}