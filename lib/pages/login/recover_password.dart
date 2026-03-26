import 'package:flutter/material.dart';
import 'package:verleihapp/services/auth_service.dart';
import 'package:verleihapp/pages/login/pre_login.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class RecoverPasswordPage extends StatefulWidget {
  final String email;
  final String code;
  
  const RecoverPasswordPage({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
    });
    try {
      final success = await AuthService().changePasswordWithCode(
        email: widget.email,
        code: widget.code,
        newPassword: _newPasswordController.text,
      );

      if (!mounted) return;
      if (success) {
        SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.passwordChangedSuccess);
        await AuthService().signout();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PreLogin()),
        );
      } else {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }


  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.resetPasswordTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(
                AppLocalizations.of(context)!.codeVerifiedMessage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.newPassword,
                  border: OutlineInputBorder(),
                ),
                autofillHints: const [AutofillHints.newPassword],
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.newPasswordRequired;
                  }
                  if (value.length < 6) {
                    return AppLocalizations.of(context)!.passwordMinLengthError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.confirmPassword,
                  border: OutlineInputBorder(),
                ),
                autofillHints: const [AutofillHints.newPassword],
                obscureText: true,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return AppLocalizations.of(context)!.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(AppLocalizations.of(context)!.changePassword),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}


