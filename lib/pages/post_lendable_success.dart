import 'package:flutter/material.dart';
import 'package:verleihapp/pages/home.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class PostLendableSuccessPage extends StatelessWidget {
  const PostLendableSuccessPage({super.key});

  // UI-Konstanten
  static const double _iconSize = 60.0;
  static const double _avatarRadius = 50.0;
  static const double _titleFontSize = 32.0;
  static const double _messageFontSize = 20.0;
  static const double _spacing = 20.0;
  static const double _bottomSpacing = 80.0;
  static const double _horizontalPadding = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSuccessIcon(),
            SizedBox(height: _spacing),
            _buildSuccessTitle(),
            SizedBox(height: _spacing),
            _buildSuccessMessage(),
            SizedBox(height: _bottomSpacing),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return CircleAvatar(
      radius: _avatarRadius,
      backgroundColor: Colors.green.shade100,
      child: Icon(
        Icons.check,
        color: Colors.green,
        size: _iconSize,
      ),
    );
  }

  Widget _buildSuccessTitle() {
    return Builder(
      builder: (context) => Text(
        AppLocalizations.of(context)!.articleSavedSuccessTitle,
        style: TextStyle(
          fontSize: _titleFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade800,
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Builder(
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: Text(
          AppLocalizations.of(context)!.articleSavedSuccessMessage,
          style: TextStyle(fontSize: _messageFontSize),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToHome(context),
      child: Text(AppLocalizations.of(context)!.continueButton),
    );
  }

  void _navigateToHome(BuildContext context) {
    NavigationUtils.navigateToAndClearStack(
      context,
      HomePage(initialIndex: 4),
    );
  }
}
