import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/models/group_model.dart';
import 'package:verleihapp/models/user_model.dart';

class GroupService {
  final SupabaseClient _db = Supabase.instance.client;

  /// Retrieves all groups for a specific user.
  /// Performs a join between group_members and groups to filter.
  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      final response = await _db
          .from('group_members')
          .select('role, groups (*)')
          .eq('user_id', userId);

      final List<GroupModel> groups = [];
      for (var item in response) {
        if (item['groups'] == null) continue;
        
        final groupData = Map<String, dynamic>.from(item['groups']);
        // Inject current user's role into the group data
        groupData['currentUserRole'] = item['role'];
        
        groups.add(GroupModel.fromJson(groupData));
      }
      
      // Sort groups alphabetically by name
      groups.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      
      return groups;
    } catch (e) {
      throw Exception('Error fetching user groups: $e');
    }
  }

  /// Retrieves a single group by ID including the current user's role.
  Future<GroupModel?> getGroup(String groupId, String userId) async {
    try {
      final response = await _db
          .from('group_members')
          .select('role, groups (*)')
          .eq('group_id', groupId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null || response['groups'] == null) return null;

      final groupData = Map<String, dynamic>.from(response['groups']);
      groupData['currentUserRole'] = response['role'];
      
      return GroupModel.fromJson(groupData);
    } catch (e) {
      throw Exception('Error fetching group: $e');
    }
  }

  /// Creates a new group and adds the creator as admin.
  Future<GroupModel> createGroup({
    required String name,
    String? description,
    String? icon,
    required String adminId,
  }) async {
    try {
      // 1. Insert group (group_code is generated via trigger)
      final groupResponse = await _db
          .from('groups')
          .insert({
            'name': name,
            'description': description,
            'icon': icon,
            'created': DateTime.now().toUtc().toIso8601String(),
          })
          .select()
          .single();

      final groupId = groupResponse['id'] as String;

      // 2. Add creator as admin
      await _db.from('group_members').insert({
        'group_id': groupId,
        'user_id': adminId,
        'role': 'admin',
        'joined_at': DateTime.now().toUtc().toIso8601String(),
      });

      // Inject role for the returned model
      final groupData = Map<String, dynamic>.from(groupResponse);
      groupData['currentUserRole'] = 'admin';

      return GroupModel.fromJson(groupData);
    } catch (e) {
      throw Exception('Error creating group: $e');
    }
  }

  /// Updates an existing group.
  Future<void> updateGroup({
    required String groupId,
    required String name,
    String? description,
    String? icon,
  }) async {
    try {
      await _db.from('groups').update({
        'name': name,
        'description': description,
        'icon': icon,
      }).eq('id', groupId);
    } catch (e) {
      throw Exception('Error updating group: $e');
    }
  }

  /// Regenerates a new join code for the group using a database function.
  Future<String> renewGroupCode(String groupId) async {
    try {
      final response = await _db.rpc(
        'renew_group_code',
        params: {'p_group_id': groupId},
      );
      return response.toString();
    } catch (e) {
      throw Exception('Error renewing group code: $e');
    }
  }

  /// Joins a group using a group code.
  Future<void> joinGroup(String code, String userId) async {
    try {
      // Normalize code: remove spaces and hyphens
      final normalizedCode = code.toUpperCase().replaceAll(' ', '').replaceAll('-', '');
      
      // Group codes are stored as XXX-XXX in the database (6 characters + hyphen)
      if (normalizedCode.length != 6) {
        throw Exception('Invalid group code format. Expected 6 characters.');
      }

      final searchCode = '${normalizedCode.substring(0, 3)}-${normalizedCode.substring(3, 6)}';

      // 1. Find group by code (always using the hyphenated version)
      final groupResponse = await _db
          .from('groups')
          .select()
          .eq('group_code', searchCode)
          .maybeSingle();

      if (groupResponse == null) {
        throw Exception('Group with this code not found');
      }

      final groupId = groupResponse['id'] as String;
      await _memberJoinLogic(groupId, userId);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error joining group: $e');
    }
  }

  /// Internal helper for join logic after group is found
  Future<void> _memberJoinLogic(String groupId, String userId) async {
    // 2. Check if already a member
    final existingMember = await _db
        .from('group_members')
        .select()
        .eq('group_id', groupId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existingMember != null) {
      throw Exception('You are already a member of this group');
    }

    // 3. Join group
    await _db.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
      'role': 'member',
      'joined_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Removes a member from a group (leaves or kicks).
  /// If the last admin leaves, another member is promoted to admin.
  Future<void> removeMember(String groupId, String userId) async {
    try {
      // 1. Get all members to check roles
      final response = await _db
          .from('group_members')
          .select()
          .eq('group_id', groupId);

      final List<Map<String, dynamic>> membersData = List<Map<String, dynamic>>.from(response);
      final memberToRemove = membersData.firstWhere((m) => m['user_id'] == userId, orElse: () => {});
      
      if (memberToRemove.isEmpty) return;

      final isRemovingAdmin = memberToRemove['role'] == 'admin';
      
      if (isRemovingAdmin) {
        final otherAdmins = membersData.where((m) => m['role'] == 'admin' && m['user_id'] != userId).toList();
        
        if (otherAdmins.isEmpty) {
          // No other admins left, try to promote someone
          final otherMembers = membersData.where((m) => m['user_id'] != userId).toList();
          if (otherMembers.isNotEmpty) {
            // Promote the first available member to admin
            await _db
                .from('group_members')
                .update({'role': 'admin'})
                .eq('group_id', groupId)
                .eq('user_id', otherMembers.first['user_id']);
          } else {
            // Last member is leaving/being removed, group will be empty.
            // Optional: deleteGroup(groupId);
          }
        }
      }

      // 2. Remove the member
      await _db
          .from('group_members')
          .delete()
          .eq('group_id', groupId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error removing member: $e');
    }
  }

  /// Updates the role of a group member (e.g., promote to admin).
  Future<void> updateMemberRole(String groupId, String userId, String newRole) async {
    try {
      await _db
          .from('group_members')
          .update({'role': newRole})
          .eq('group_id', groupId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error updating member role: $e');
    }
  }

  /// Deletes a group entirely.
  /// Cascading deletes should handle group_members in the database.
  Future<void> deleteGroup(String groupId) async {
    try {
      await _db
          .from('groups')
          .delete()
          .eq('id', groupId);
    } catch (e) {
      throw Exception('Error deleting group: $e');
    }
  }

  /// Retrieves all members of a specific group including their roles and profiles.
  Future<List<GroupMemberModel>> getGroupMembers(String groupId) async {
    try {
      // 1. Fetch group members (roles and user_ids)
      final membersResponse = await _db
          .from('group_members')
          .select()
          .eq('group_id', groupId);

      final List<Map<String, dynamic>> membersData = List<Map<String, dynamic>>.from(membersResponse);
      if (membersData.isEmpty) return [];

      final userIds = membersData.map((m) => m['user_id'] as String).toList();

      // 2. Fetch profiles for these users
      final profilesResponse = await _db
          .from('profiles')
          .select()
          .inFilter('id', userIds);

      final List<Map<String, dynamic>> profilesData = List<Map<String, dynamic>>.from(profilesResponse);
      final Map<String, UserModel> profilesMap = {
        for (var p in profilesData) 
          p['id'] as String : UserModel.fromJson(p, p['id'] as String)
      };

      // 3. Combine role and profile
      final List<GroupMemberModel> members = [];
      for (var memberData in membersData) {
        final userId = memberData['user_id'] as String;
        members.add(GroupMemberModel.fromJson(
          memberData, 
          user: profilesMap[userId]
        ));
      }
      
      // Sort members: Admins first, then by first name
      members.sort((a, b) {
        if (a.role == 'admin' && b.role != 'admin') return -1;
        if (a.role != 'admin' && b.role == 'admin') return 1;
        
        final nameA = a.user?.firstName.toLowerCase() ?? '';
        final nameB = b.user?.firstName.toLowerCase() ?? '';
        return nameA.compareTo(nameB);
      });
      
      return members;
    } catch (e) {
      throw Exception('Error fetching group members: $e');
    }
  }
}
