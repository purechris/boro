import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:verleihapp/config/constants.dart';
import 'package:verleihapp/models/friend_request_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/services/user_service.dart';

class FriendService {
  final SupabaseClient _db = Supabase.instance.client;
  final UserService _userService = UserService();

  /// Get all friends of a user.
  Future<List<UserModel>> getFriends(String userId) async {
    try {
      final response1 = await _db
          .from(AppConstants.tableFriends)
          .select('user_id_2')
          .eq('user_id_1', userId);

      final response2 = await _db
          .from(AppConstants.tableFriends)
          .select('user_id_1')
          .eq('user_id_2', userId);

      final friendIds = [
        ...response1.map((item) => item['user_id_2'] as String),
        ...response2.map((item) => item['user_id_1'] as String),
      ];

      if (friendIds.isEmpty) return [];

      final userResponse = await _db
          .from(AppConstants.tableProfiles)
          .select('*')
          .inFilter('id', friendIds);

      final friends = (userResponse as List).map((userData) {
        return UserModel.fromJson(userData, userData['id'] as String);
      }).toList();

      // Sort alphabetically by first name
      friends.sort((a, b) {
        return a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
      });

      return friends;
    } catch (e) {
      debugPrint('Error getting friends: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Create a new friend request.
  Future<void> createFriendRequest(String senderUserId, String receiverUserId) async {
    try {
      // Check if friendship already exists
      final existingFriendship = await _db
          .from(AppConstants.tableFriends)
          .select()
          .or('and(user_id_1.eq.$senderUserId,user_id_2.eq.$receiverUserId),and(user_id_1.eq.$receiverUserId,user_id_2.eq.$senderUserId)')
          .maybeSingle();

      if (existingFriendship != null) {
        throw Exception(AppConstants.errorFriendAlreadyExists);
      }

      // Check if an open request already exists
      final existingRequest = await _db
          .from('friend_requests')
          .select()
          .or('and(sender_user_id.eq.$senderUserId,receiver_user_id.eq.$receiverUserId),and(sender_user_id.eq.$receiverUserId,receiver_user_id.eq.$senderUserId)')
          .maybeSingle();

      if (existingRequest != null) {
        throw Exception(AppConstants.errorFriendRequestExists);
      }

      await _db.from('friend_requests').insert({
        'sender_user_id': senderUserId,
        'receiver_user_id': receiverUserId,
        'created': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      if (e is Exception && e.toString().contains(AppConstants.errorFriendAlreadyExists)) {
        rethrow;
      }
      if (e is Exception && e.toString().contains(AppConstants.errorFriendRequestExists)) {
        rethrow;
      }
      debugPrint('Error creating friend request: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Create a friend request using friend code via RPC function.
  Future<String?> createFriendRequestByCode(String friendCode) async {
    try {
      final response = await _db.rpc(
        'add_friend_by_code',
        params: {'p_friend_code': friendCode},
      );

      final responseList = response as List;
      if (responseList.isEmpty) {
        throw Exception(AppConstants.errorGeneric);
      }
      
      final result = responseList.first as Map<String, dynamic>;
      final success = result['success'] as bool?;
      
      if (success != true) {
        final message = result['message'] as String?;
        throw Exception(message ?? AppConstants.errorGeneric);
      }

      return result['receiver_user_id'] as String?;
    } catch (e) {
      debugPrint('Error creating friend request by code: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Akzeptiert eine Freundschaftsanfrage
  Future<void> acceptFriendRequest(String requestId) async {
    try {
      final response = await _db
          .from('friend_requests')
          .select()
          .eq('id', requestId)
          .maybeSingle();

      if (response == null) return;

      final senderUserId = response['sender_user_id'] as String;
      final receiverUserId = response['receiver_user_id'] as String;

      await _db.from(AppConstants.tableFriends).insert({
        'user_id_1': senderUserId,
        'user_id_2': receiverUserId,
        'created': DateTime.now().toUtc().toIso8601String(),
      });

      await _db
          .from('friend_requests')
          .delete()
          .eq('id', requestId);
    } catch (e) {
      debugPrint('Error accepting friend request: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Lehnt eine Freundschaftsanfrage ab
  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await _db
          .from('friend_requests')
          .delete()
          .eq('id', requestId);
    } catch (e) {
      debugPrint('Error rejecting friend request: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Bricht eine gesendete Freundschaftsanfrage ab
  Future<void> cancelFriendRequest(String requestId) async {
    try {
      await _db
          .from('friend_requests')
          .delete()
          .eq('id', requestId);
    } catch (e) {
      debugPrint('Error cancelling friend request: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Entfernt eine Freundschaft
  Future<void> removeFriend(String userId, String friendId) async {
    try {
      await _db.from(AppConstants.tableFriends)
          .delete()
          .or('and(user_id_1.eq.$userId,user_id_2.eq.$friendId),and(user_id_1.eq.$friendId,user_id_2.eq.$userId)');
    } catch (e) {
      debugPrint('Error removing friend: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Check if two users are friends.
  Future<bool> areFriends(String userId1, String userId2) async {
    try {
      final friendship = await _db
          .from(AppConstants.tableFriends)
          .select()
          .or('and(user_id_1.eq.$userId1,user_id_2.eq.$userId2),and(user_id_1.eq.$userId2,user_id_2.eq.$userId1)')
          .maybeSingle();
      
      return friendship != null;
    } catch (e) {
      debugPrint('Error checking friendship: $e');
      return false;
    }
  }

  /// Check if a pending friend request exists between two users.
  Future<bool> hasPendingRequest(String userId1, String userId2) async {
    try {
      final request = await _db
          .from('friend_requests')
          .select()
          .or('and(sender_user_id.eq.$userId1,receiver_user_id.eq.$userId2),and(sender_user_id.eq.$userId2,receiver_user_id.eq.$userId1)')
          .maybeSingle();
      
      return request != null;
    } catch (e) {
      debugPrint('Error checking pending request: $e');
      return false;
    }
  }

  /// Get all sent friend requests.
  Future<List<FriendRequestModel>> getSentFriendRequests(String userId) async {
    try {
      final response = await _db
          .from('friend_requests')
          .select()
          .eq('sender_user_id', userId);

      final requests = <FriendRequestModel>[];
      for (var doc in response) {
        final request = FriendRequestModel.fromJson(doc, doc['id'] as String);
        final receiverUser = await _userService.getUser(request.receiverUserId);
        if (receiverUser != null) {
          request.setReceiverUser(receiverUser);
        }
        requests.add(request);
      }
      return requests;
    } catch (e) {
      debugPrint('Error getting sent friend requests: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Get all received friend requests.
  Future<List<FriendRequestModel>> getReceivedFriendRequests(String userId) async {
    try {
      final response = await _db
          .from('friend_requests')
          .select()
          .eq('receiver_user_id', userId);

      final requests = <FriendRequestModel>[];
      for (var doc in response) {
        final request = FriendRequestModel.fromJson(doc, doc['id'] as String);
        final senderUser = await _userService.getUser(request.senderUserId);
        if (senderUser != null) {
          request.setSenderUser(senderUser);
        }
        requests.add(request);
      }
      return requests;
    } catch (e) {
      debugPrint('Error getting received friend requests: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Get mutual friends between two users.
  Future<List<UserModel>> getMutualFriends(String userId1, String userId2) async {
    try {
      // Get all friends of userId1
      final friends1 = await getFriends(userId1);
      final friendIds1 = friends1.map((friend) => friend.id!).toSet();

      // Get all friends of userId2
      final friends2 = await getFriends(userId2);
      final friendIds2 = friends2.map((friend) => friend.id!).toSet();

      // Find the intersection (mutual friends)
      final mutualFriendIds = friendIds1.intersection(friendIds2);

      if (mutualFriendIds.isEmpty) return [];

      // Get the complete user data for mutual friends
      final userResponse = await _db
          .from(AppConstants.tableProfiles)
          .select('*')
          .inFilter('id', mutualFriendIds.toList());

      return (userResponse as List).map((userData) {
        return UserModel.fromJson(userData, userData['id'] as String);
      }).toList();
    } catch (e) {
      debugPrint('Error getting mutual friends: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }

  /// Get network statistics (direct and indirect) for a user.
  /// Uses the database function: public.get_friend_network_counts
  Future<Map<String, int>> getFriendNetworkCounts(String userId) async {
    try {
      final response = await _db.rpc(
        'get_friend_network_counts',
        params: {'p_user_id': userId},
      );

      if (response == null || response.isEmpty) {
        return {'direct_count': 0, 'indirect_count': 0};
      }

      // The function returns a table, we take the first element
      final result = response.first as Map<String, dynamic>;
      final directCount = (result['direct_count'] as num?)?.toInt() ?? 0;
      final indirectCount = (result['indirect_count'] as num?)?.toInt() ?? 0;

      return {
        'direct_count': directCount,
        'indirect_count': indirectCount,
      };
    } catch (e) {
      debugPrint('Error getting network counts: $e');
      throw Exception(AppConstants.errorGeneric);
    }
  }
}