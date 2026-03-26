import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/main.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';

/// Service for managing favorites in the lending app.
///
/// This service provides methods for adding, removing, and fetching favorites.
/// It interacts with the Supabase database and manages the relationship between
/// users and their favorited items.
class FavoriteService {
  static const String _noUserLoggedInError = 'No user logged in';
  static const String _addFavoriteError = 'Error adding favorite';
  static const String _removeFavoriteError = 'Error removing favorite';
  static const String _getFavoritesError = 'Error getting favorites';
  static const String _checkFavoriteError = 'Error checking favorite';

  final SupabaseClient _db = Supabase.instance.client;

  String get _currentUserId {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception(_noUserLoggedInError);
    }
    return userId;
  }

  /// Add an item to the current user's favorites.
  Future<void> addFavorite(String lendableId) async {
    try {
      final data = {
        'lendable_id': lendableId,
        'user_id': _currentUserId,
        'created': DateTime.now().toUtc().toIso8601String(),
      };

      await _db.from('favorites').insert(data);
    } catch (e) {
      throw Exception('$_addFavoriteError: $e');
    }
  }

  /// Remove an item from the current user's favorites.
  Future<void> removeFavorite(String lendableId) async {
    try {
      await _db
          .from('favorites')
          .delete()
          .eq('lendable_id', lendableId)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('$_removeFavoriteError: $e');
    }
  }

  // Lade die Artikel des aktuell eingeloggten Benutzers und seiner Freunde (wird auf der Startseite verwendet)
  Future<List<Map<LendableModel, UserModel>>> getFavorites() async {
    try {
      final response = await _db.rpc(
        'get_favorite_lendables_with_users',
        params: {'p_user_id': _currentUserId},
      );

      return (response as List).map((item) {
        final lendable = LendableModel.fromDatabaseFunction(item);
        final user = UserModel.fromDatabaseFunction(item);
        return {lendable: user};
      }).toList();
    } catch (e) {
      throw Exception('$_getFavoritesError: $e');
    }
  }

  // Überprüfe, ob ein bestimmter Artikel von dem aktuellen Benutzer favorisiert wurde
  Future<bool> checkIfFavorite(String lendableId) async {
    try {
      final response = await _db
          .from('favorites')
          .select('*')
          .eq('lendable_id', lendableId)
          .eq('user_id', _currentUserId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('$_checkFavoriteError: $e');
    }
  }
}