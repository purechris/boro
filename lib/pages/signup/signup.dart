import 'package:verleihapp/pages/login/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/services/auth_service.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/utils/password_validator.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _signin(),
      appBar: appBar(),
      body: SafeArea(
        bottom: true, // Explizit unten berücksichtigen für transparente Navigationsleiste
        child: SingleChildScrollView(
         padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30,),
                _buildCenteredImage(),
                const SizedBox(height: 30,),
                _emailAddress(),
                const SizedBox(height: 20,),
                _password(),
                const SizedBox(height: 20,),
                _firstName(),
                const SizedBox(height: 30,),
                _signup(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstName() {
    return TextFormField(
      controller: _firstNameController,
      autofillHints: const [AutofillHints.name],
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.displayName,
        helperText: AppLocalizations.of(context)!.displayNameHint,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)!.displayNameRequired;
        }
        if (value.trim().length > 20) {
          return AppLocalizations.of(context)!.nameMaxLength;
        }
        return null;
      },
    );
  }

  Widget _emailAddress() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.emailAddress,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)!.emailRequired;
        }
        if (!value.contains('@') || !value.contains('.')) {
          return AppLocalizations.of(context)!.emailInvalid;
        }
        return null;
      },
    );
  }

  Widget _password() {
    final password = _passwordController.text;
    final isMetLength = password.length >= PasswordValidator.minLength &&
        password.length <= PasswordValidator.maxLength;
    final isMetUppercase = password.contains(RegExp(r'[A-Z]'));
    final isMetLowercase = password.contains(RegExp(r'[a-z]'));
    final isMetDigits = password.contains(RegExp(r'[0-9]'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          autofillHints: const [AutofillHints.newPassword],
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.password,
            border: OutlineInputBorder(),
            errorMaxLines: 3,
          ),
          onChanged: (value) {
            setState(() {
              // Trigger rebuild to update requirements display
            });
          },
          validator: (value) {
            final errorKey = PasswordValidator.validate(value);
            if (errorKey != null) {
              return AppLocalizations.of(context)!.passwordDoesNotMeetRequirements;
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

  Widget _signup() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _submitForm(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.register,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final firstName = _firstNameController.text.trim();

    try {
      await AuthService().signup(email: email, password: password, firstName: firstName);
      if (!mounted) return;
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.confirmationEmailSent(email));
      await NavigationUtils.navigateTo(context, Login(), clearStack: true);
    } on AuthException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final errorCode = AuthService.mapSignupError(e);
      String message;
      switch (errorCode) {
        case 'TOO_MANY_ATTEMPTS':
          message = l10n.tooManyRegistrationAttempts;
          break;
        case 'PASSWORD_REQUIREMENTS':
          message = l10n.passwordDoesNotMeetRequirements;
          break;
        default:
          message = l10n.errorOccurred;
      }
      SnackbarUtils.showError(context, message);
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      if (e.toString().contains('SocketException')) {
        SnackbarUtils.showError(context, l10n.noInternetConnection);
      } else {
        SnackbarUtils.showError(context, l10n.errorOccurred);
      }
    }
  }

  Widget _signin() {
    return SafeArea(
      top: false,
      bottom: true, // Berücksichtige die Android-System-Navigationsbuttons
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: AppLocalizations.of(context)!.accountAlreadyExists,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!.signIn,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login()
                        ),
                      );
                    }
                ),
            ]
          )
        ),
      ),
    );
  }

    AppBar appBar() {
    return AppBar(
      centerTitle: true,
    );
  }

  Widget _buildCenteredImage() {
  return Center(
    child: Image.asset(
      'assets/pictures/logo.png',
      height: 120,
      fit: BoxFit.contain,
    ),
  );
}

}