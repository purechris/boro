import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verleihapp/services/auth_service.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/pages/login/recover_password.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class VerifyRecoveryCodePage extends StatefulWidget {
  final String email;
  
  const VerifyRecoveryCodePage({
    super.key,
    required this.email,
  });

  @override
  State<VerifyRecoveryCodePage> createState() => _VerifyRecoveryCodePageState();
}

class _VerifyRecoveryCodePageState extends State<VerifyRecoveryCodePage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _enteredCode {
    return _controllers.map((controller) => controller.text).join();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, try to verify
        _verifyCode();
      }
    } else {
      // Move to previous field
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  Future<void> _verifyCode() async {
    if (_enteredCode.length != 6) {
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.enterFullCode);
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      final success = await AuthService().verifyRecoveryCode(
        email: widget.email,
        code: _enteredCode,
      );

      if (!mounted) return;
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RecoverPasswordPage(email: widget.email, code: _enteredCode),
          ),
        );
      } else {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.invalidOrExpiredCode);
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const SizedBox(height: 20),
            Icon(
              Icons.email_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.enterCode,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.codeSentToEmail(widget.email),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Code input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 55,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) => _onDigitChanged(value, index),
                    onTap: () {
                      _controllers[index].selection = TextSelection.fromPosition(
                        TextPosition(offset: _controllers[index].text.length),
                      );
                    },
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 32),
            
            // Verify button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verifyCode,
                child: _isVerifying
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(AppLocalizations.of(context)!.verifyCode),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
          ),
        ),
      ),
    );
  }
}
