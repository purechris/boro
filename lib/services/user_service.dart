import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/config/supabase_config.dart';

class UserService {
  static const String _noUserLoggedInError = 'No user logged in';
  static const String _userError = 'Error during user operation';
  static const String _userNotFoundError = 'User not found';

  final SupabaseClient _db = Supabase.instance.client;

  /// Get the ID of the currently logged-in user.
  String getCurrentUserId() {
    final user = _db.auth.currentUser;
    if (user == null) throw Exception(_noUserLoggedInError);
    return user.id;
  }

  /// Check if the currently logged-in user is a demo user.
  bool isDemoUser() {
    final user = _db.auth.currentUser;
    if (user == null) return false;
    return user.email == SupabaseConfig.demoEmail;
  }

  /// Create a new user profile.
  Future<void> createUser(UserModel user) async {
    try {
      await _db.from('profiles').insert(user.toJson());
    } catch (e) {
      throw Exception('$_userError: $e');
    }
  }

  /// Load a user by their ID.
  Future<UserModel?> getUser(String userId) async {
    try {
      final response = await _db.from('profiles').select().eq('id', userId).maybeSingle();
      if (response == null) throw Exception(_userNotFoundError);
      return UserModel.fromJson(response, userId);
    } catch (e) {
      throw Exception('$_userError: $e');
    }
  }

  /// Update a user.
  Future<void> updateUser(UserModel user) async {
    try {
      await _db.from('profiles').update(user.toJson()).eq('id', user.id!);
    } catch (e) {
      throw Exception('$_userError: $e');
    }
  }

  /// Load the currently logged-in user.
  Future<UserModel?> getCurrentUser() async {
    final user = _db.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await _db.from('profiles').select().eq('id', user.id).single();
      return UserModel.fromJson(response, user.id);
    } catch (e) {
      throw Exception('$_userError: $e');
    }
  }

  /// Load a user by their friend code.
  Future<UserModel?> getUserByFriendCode(String friendCode) async {
    try {
      final normalizedCode = friendCode.toUpperCase().replaceAll(' ', '').replaceAll('-', '');
      
      // Validate format: Must be exactly 8 characters (4 letters + 4 digits)
      if (normalizedCode.length != 8) {
        return null; // Invalid format
      }
      
      // Format to XX##-XX## format for search
      final formattedCode = '${normalizedCode.substring(0, 4)}-${normalizedCode.substring(4, 8)}';
      
      final response = await _db
          .from('profiles')
          .select()
          .eq('friend_code', formattedCode)
          .maybeSingle();
      
      if (response == null) return null;
      return UserModel.fromJson(response, response['id']);
    } catch (e) {
      throw Exception('$_userError: $e');
    }
  }
}
