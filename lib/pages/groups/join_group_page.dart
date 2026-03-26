import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/services/group_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final _codeController = TextEditingController();
  final _groupService = GroupService();
  final _userService = UserService();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.joinGroup),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: l10n.groupCode,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _userService.isDemoUser() ? null : (_isLoading ? null : _handleJoin),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                  )
                : Text(l10n.joinGroup),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleJoin() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.enterGroupCode);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = _userService.getCurrentUserId();
      await _groupService.joinGroup(code, userId);
      
      if (!mounted) return;
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.joinGroupSuccess);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
