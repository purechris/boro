import 'package:verleihapp/pages/signup/signup.dart';
import 'package:verleihapp/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/pages/home.dart';
import 'package:verleihapp/pages/login/reset_password.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _signup(),
      appBar: AppBar(),
      body: SafeArea(
        bottom: true, // Explizit unten berücksichtigen für transparente Navigationsleiste
        child: SingleChildScrollView(
         padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              _buildCenteredImage(),
              const SizedBox(height: 30,),
              _emailAddress(),
              const SizedBox(height: 20,),
              _password(),
              const SizedBox(height: 10,),
              _resetPassword(),
              const SizedBox(height: 20,),
              _signin(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _emailAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _emailController,
          autofillHints: const [AutofillHints.email],
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.emailAddress,
            border: OutlineInputBorder(),
          ),
        )
      ],
    );
  }

  Widget _password() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          obscureText: true,
          controller: _passwordController,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.password,
            border: OutlineInputBorder(),
          ),
        )
      ],
    );
  }

  Widget _resetPassword() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.passwordForgotten,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordPage(),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.reset,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _signin() {
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
          AppLocalizations.of(context)!.signIn,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  void _submitForm() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.emailAndPasswordRequired);
      }
      return;
    }

    try {
      await AuthService().signin(email: email, password: password);
      if (!mounted) return;
      await NavigationUtils.navigateTo(context, HomePage(), clearStack: true);
    } on AuthException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      if (e.code == 'email_not_confirmed') {
        SnackbarUtils.showError(context, l10n.emailNotConfirmed);
      } else if (e.code == 'invalid_credentials') {
        SnackbarUtils.showError(context, l10n.invalidCredentials);
      } else {
        SnackbarUtils.showError(context, l10n.errorOccurred);
      }
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
    }
  }

  Widget _signup() {
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
                text: AppLocalizations.of(context)!.noAccountYet,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16
                ),
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.register,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signup()
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