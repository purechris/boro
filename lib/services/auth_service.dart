import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:verleihapp/config/constants.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/config/supabase_config.dart';

class AuthService {

  final UserService _userService = UserService();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signup({
    required String email,
    required String password,
    required String firstName,
  }) async {
    final AuthResponse response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    final hasNewIdentity = user != null && (user.identities?.isNotEmpty ?? false);

    if (!hasNewIdentity) {
      await _handleExistingAccountSignup(email: email);
      return;
    }

    await _handleSuccessfulSignup(
      response: response,
      email: email,
      firstName: firstName,
    );
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInAsDemo() async {
    await _supabase.auth.signInWithPassword(
      email: SupabaseConfig.demoEmail,
      password: SupabaseConfig.demoPassword,
    );
  }

  Future<void> signout() async {
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<bool> verifyRecoveryCode({
    required String email,
    required String code,
  }) async {
    final response = await _supabase.auth.verifyOTP(
      type: OtpType.recovery,
      token: code,
      email: email,
    );
    return response.user != null;
  }

  Future<bool> changePasswordWithCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final response = await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    return response.user != null;
  }

  Future<void> _handleSuccessfulSignup({
    required AuthResponse response,
    required String email,
    required String firstName,
  }) async {
    final user = response.user;
    if (user == null) {
      throw Exception('Signup failed - no user received.');
    }

    final userModel = UserModel(
      id: user.id,
      email: email,
      firstName: firstName,
      created: DateTime.now(),
    );

    try {
      await _userService.createUser(userModel);
    } catch (e, stackTrace) {
      // Log the error but don't rethrow, as the auth signup was successful
      debugPrint('Error creating user profile after signup: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  Future<void> _handleExistingAccountSignup({required String email}) async {
    await _sendExistingAccountEmail(email);
  }

  Future<void> _sendExistingAccountEmail(String email) async {
    try {
      await _supabase.rpc(
        'send_existing_account_notification',
        params: {'recipient_email': email},
      );
    } catch (e, stackTrace) {
      // Log the error but don't rethrow
      debugPrint('Error sending existing account notification: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  static String mapSignupError(AuthException exception) {
    final rawMessage = exception.message;
    final message = rawMessage.toLowerCase();

    if (exception.statusCode == '429') {
      return AppConstants.errorAuthTooManyAttempts;
    }

    if (message.contains('password')) {
      return AppConstants.errorAuthPasswordRequirements;
    }

    return AppConstants.errorAuthSignupFailed;
  }
}
