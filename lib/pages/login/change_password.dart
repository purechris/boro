import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/utils/password_validator.dart';
import 'package:verleihapp/services/user_service.dart';

// Supabase Client
final supabase = Supabase.instance.client;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;

  Widget _buildNewPasswordField() {
    final password = _newPasswordController.text;
    final isMetLength = password.length >= PasswordValidator.minLength &&
        password.length <= PasswordValidator.maxLength;
    final isMetUppercase = password.contains(RegExp(r'[A-Z]'));
    final isMetLowercase = password.contains(RegExp(r'[a-z]'));
    final isMetDigits = password.contains(RegExp(r'[0-9]'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _newPasswordController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.newPassword,
            border: OutlineInputBorder(),
            errorMaxLines: 3,
          ),
          autofillHints: const [AutofillHints.newPassword],
          obscureText: true,
          onChanged: (value) {
            setState(() {
              // Trigger rebuild to update requirements display
            });
          },
          validator: (value) {
            // Check if password meets requirements
            final errorKey = PasswordValidator.validate(value);
            if (errorKey != null) {
              return AppLocalizations.of(context)!.passwordDoesNotMeetRequirements;
            }
            
            // Check if new password is same as current password
            if (value == _currentPasswordController.text) {
              return AppLocalizations.of(context)!.newPasswordSameAsOld;
            }
            
            return null;
          },
        ),
        if (password.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildPasswordRequirement(
            'Länge: 8-72 Zeichen',
            isMetLength,
          ),
          _buildPasswordRequirement(
            'Großbuchstaben (A-Z)',
            isMetUppercase,
          ),
          _buildPasswordRequirement(
            'Kleinbuchstaben (a-z)',
            isMetLowercase,
          ),
          _buildPasswordRequirement(
            'Ziffern (0-9)',
            isMetDigits,
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check : Icons.close,
            size: 18,
            color: isMet ? Colors.green : Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isMet ? Colors.green : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Prüfen des aktuellen Passworts
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      await supabase.auth.signInWithPassword(
        email: currentUser.email!,
        password: _currentPasswordController.text,
      );
      
      // Wenn die Authentifizierung erfolgreich war, Passwort aktualisieren
      await supabase.auth.updateUser(
        UserAttributes(
          password: _newPasswordController.text,
        ),
      );
      
      if (mounted) {
        SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.passwordChangedSuccess);
        Navigator.of(context).pop(); // Zurück zu den Einstellungen
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('Invalid login credentials')) {
          SnackbarUtils.showError(context, AppLocalizations.of(context)!.currentPasswordIncorrect);
        } else {
          SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changePassword),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                TextFormField(
                  controller: _currentPasswordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.currentPassword,
                    border: OutlineInputBorder(),
                  ),
                  autofillHints: const [AutofillHints.password],
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.currentPasswordRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildNewPasswordField(),
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
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: _userService.isDemoUser() ? null : _updatePassword,
                      child: Text(AppLocalizations.of(context)!.changePassword),
                    ),
                  ),
                ),
              ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
} 