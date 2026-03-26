import 'package:flutter/material.dart';
import 'package:verleihapp/services/auth_service.dart';
import 'package:verleihapp/pages/login/verify_recovery_code.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.resetPasswordTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.resetPasswordDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.emailAddress,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.emailRequiredForReset;
                    }
                    if (!value.contains('@')) {
                      return AppLocalizations.of(context)!.emailInvalidForReset;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: _submitResetRequest,
                      child: Text(AppLocalizations.of(context)!.sendCode),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitResetRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    try {
      await AuthService().resetPassword(email: email);
      if (!mounted) return;
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.codeSentToEmail(email));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VerifyRecoveryCodePage(email: email),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
} 