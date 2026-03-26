import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/pages/login/pre_login.dart';
import 'package:verleihapp/services/auth_service.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';

class DemoModeBanner extends StatelessWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            AppLocalizations.of(context)!.demoBannerClickToExit,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
