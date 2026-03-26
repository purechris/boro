import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/config/constants.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/services/file_service.dart';
import 'package:verleihapp/services/user_service.dart';

class LendableService {
  final SupabaseClient _db = Supabase.instance.client;
  final UserService _userService = UserService();
  final FileService _fileService = FileService();

  final testList = [{LendableModel.getTestLendable(): UserModel.getTestUser()}];

  /// Add a new item to the lendable collection.
  Future<String> addLendable(LendableModel lendable) async {
    try {
      // Convert to JSON
      final json = lendable.toJson();

      // Store item in Supabase. If an ID exists, it will be used,
      // otherwise Supabase generates a new ID.
      if (lendable.id.isEmpty) {
        json.remove(AppConstants.keyId);
      }

      final response = await _db.from(AppConstants.tableLendables).insert(json).select(AppConstants.keyId).single();
      final String lendableId = response[AppConstants.keyId] as String;

      // If specific groups were selected, store them in lendable_groups
      if (lendable.groupVisibility == VisibilityMode.specific.value && lendable.groupIds.isNotEmpty) {
        await _insertLendableGroups(lendableId, lendable.groupIds);
      }

      return lendableId;
    } catch (e) {
      debugPrint('Add article failed: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Update an existing item.
  Future<void> updateLendable(LendableModel lendable) async {
    try {
      // Fetch the current lendable record from Supabase
      final currentLendable = await _db.from(AppConstants.tableLendables).select().eq(AppConstants.keyId, lendable.id).single();

      // Check if image URL or file name has changed
      String? currentImageUrl = currentLendable['image_url'];
      String? currentImageFileName = currentLendable['image_file_name'];
      
      if ((currentImageUrl != null && currentImageUrl.isNotEmpty && lendable.imageUrl != currentImageUrl) ||
          (currentImageFileName != null && currentImageFileName.isNotEmpty && lendable.imageFileName != currentImageFileName)) {
        // Delete old image from storage
        await _fileService.deleteLendableImage(lendable.userId, lendable.id, fileName: currentImageFileName);
      }

      // Update item in Supabase.
      // If the edit form doesn't handle `borrowedBy`, it should not be accidentally deleted on update.
      final updateJson = lendable.toJson();
      if (lendable.borrowedBy == null) {
        updateJson.remove('borrowed_by');
      }
      await _db.from(AppConstants.tableLendables).update(updateJson).eq(AppConstants.keyId, lendable.id);

      // Synchronize group associations
      // 1. Delete all old associations
      await _db.from(AppConstants.tableLendableGroups).delete().eq('lendable_id', lendable.id);

      // 2. Add new associations (if specific)
      if (lendable.groupVisibility == VisibilityMode.specific.value && lendable.groupIds.isNotEmpty) {
        await _insertLendableGroups(lendable.id, lendable.groupIds);
      }
    } catch (e) {
      debugPrint('Update article failed: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Helper to insert group associations for a lendable item.
  Future<void> _insertLendableGroups(String lendableId, List<String> groupIds) async {
    final String currentUserId = _userService.getCurrentUserId();
    final List<Map<String, dynamic>> groupEntries = groupIds.map((groupId) => {
      'lendable_id': lendableId,
      'group_id': groupId,
      'user_id': currentUserId,
    }).toList();
    await _db.from(AppConstants.tableLendableGroups).insert(groupEntries);
  }

  /// Set the name of the person who borrowed this item.
  Future<void> setBorrowedBy(String lendableId, String? borrowerName) async {
    try {
      final String? trimmed = borrowerName?.trim();
      await _db.from(AppConstants.tableLendables).update({
        'borrowed_by': (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      }).eq(AppConstants.keyId, lendableId);
    } catch (e) {
      throw Exception('Set borrowed_by failed: $e');
    }
  }

  /// Fetch a single lendable item by ID.
  Future<LendableModel> getLendable(String lendableId) async {
    try {
      // Fetch item from the "lendables" table
      final lendableData = await _db
          .from(AppConstants.tableLendables)
          .select('*')
          .eq(AppConstants.keyId, lendableId)
          .single();

      // Also fetch associated group IDs if any
      final groupsResponse = await _db
          .from(AppConstants.tableLendableGroups)
          .select('group_id')
          .eq('lendable_id', lendableId);
      
      final List<String> groupIds = (groupsResponse as List)
          .map((item) => item['group_id'].toString())
          .toList();
      
      final Map<String, dynamic> fullData = Map<String, dynamic>.from(lendableData);
      fullData['group_ids'] = groupIds;

      return LendableModel.fromJson(fullData);
    } catch (e) {
      throw Exception('Get article failed: $e');
    }
  }

  /// Delete an item based on its ID.
  Future<void> deleteLendable(String lendableId) async {
    try {
      final userId = _userService.getCurrentUserId();

      // Delete from the "lendables" table
      await _db.from(AppConstants.tableLendables).delete().eq(AppConstants.keyId, lendableId);

      await _fileService.deleteLendableImage(userId, lendableId);
    } catch (e) {
      throw Exception('Delete article failed: $e');
    }
  }

  /// Fetch items for the currently logged-in user and their friends (used on the start page).
  /// IMPORTANT: If the LendableModel is extended, the Supabase functions must be updated via SQL!
  /// The Supabase editor cannot modify the returned table structure.
  /// Function: get_lendables_with_user_data
  Future<List<Map<LendableModel, UserModel>>> getLendablesForStartPage() async {
    try {
      final currentUserId = _userService.getCurrentUserId();
      final response = await _db.rpc(AppConstants.rpcGetLendablesForStartPage, params: {'p_user_id': currentUserId});

      List<Map<LendableModel, UserModel>> result = (response as List).map((item) {
        LendableModel lendable = LendableModel.fromDatabaseFunction(item);
        UserModel user = UserModel.fromDatabaseFunction(item);
        return {lendable: user};
      }).toList();

      return result;
    } catch (e) {
      throw Exception('Get articles failed: $e');
    }
  }

  /// Fetch items for the logged-in user's private profile.
  Future<List<Map<LendableModel, UserModel>>> getLendablesForPrivateProfile() async {
    // Fetch the current user
    final currentUserId = _userService.getCurrentUserId();
    return fetchLendablesForSpecificUser(currentUserId);
  }

  /// Fetch items for a specific user ID (for private profile - all items visible).
  /// IMPORTANT: If the LendableModel is extended, the Supabase functions must be updated via SQL!
  /// The Supabase editor cannot modify the returned table structure.
  /// Function: get_lendables_from_specific_user
  Future<List<Map<LendableModel, UserModel>>> fetchLendablesForSpecificUser(String userId) async {
    try {
      final response = await _db.rpc(AppConstants.rpcGetLendablesFromSpecificUser, params: {'p_user_id': userId});

      List<Map<LendableModel, UserModel>> result = (response as List).map((item) {
        LendableModel lendable = LendableModel.fromDatabaseFunction(item);
        UserModel user = UserModel.fromDatabaseFunction(item);
        return {lendable: user};
      }).toList();

      return result;
    } catch (e) {
      throw Exception('Get articles failed: $e');
    }
  }

  /// Fetch items for a public profile (with visibility filtering).
  /// IMPORTANT: If the LendableModel is extended, the Supabase functions must be updated via SQL!
  /// The Supabase editor cannot modify the returned table structure.
  /// Function: get_lendables_for_public_profile
  Future<List<Map<LendableModel, UserModel>>> fetchLendablesForPublicProfile(String userId) async {
    try {
      final currentUserId = _userService.getCurrentUserId();
      final response = await _db.rpc(AppConstants.rpcGetLendablesForPublicProfile, 
        params: {'p_user_id': userId, 'p_viewer_id': currentUserId});

      List<Map<LendableModel, UserModel>> result = (response as List).map((item) {
        LendableModel lendable = LendableModel.fromDatabaseFunction(item);
        UserModel user = UserModel.fromDatabaseFunction(item);
        return {lendable: user};
      }).toList();

      return result;
    } catch (e) {
      throw Exception('Get articles failed: $e');
    }
  }

  /// Fetch all items shared with a specific group.
  Future<List<Map<LendableModel, UserModel>>> fetchGroupLendables(String groupId) async {
    try {
      final currentUserId = _userService.getCurrentUserId();
      final response = await _db.rpc(AppConstants.rpcGetLendablesForGroup, params: {
        'p_group_id': groupId,
        'p_viewer_id': currentUserId,
      });

      List<Map<LendableModel, UserModel>> result = (response as List).map((item) {
        LendableModel lendable = LendableModel.fromDatabaseFunction(item);
        UserModel user = UserModel.fromDatabaseFunction(item);
        return {lendable: user};
      }).toList();

      return result;
    } catch (e) {
      throw Exception('Get group articles failed: $e');
    }
  }
}
