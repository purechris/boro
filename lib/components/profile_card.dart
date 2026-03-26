import 'package:flutter/material.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/models/badge_model.dart';
import 'package:verleihapp/components/badge_widget.dart';
import 'package:verleihapp/services/friend_service.dart';
import 'package:verleihapp/services/lendable_service.dart';
import 'package:verleihapp/utils/avatar_color_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class ProfileCard extends StatelessWidget {
  final Future<UserModel?>? futureUser;
  final UserModel? user;
  final String? currentUserId; // For mutual friends

  const ProfileCard({
    super.key,
    this.futureUser,
    this.user,
    this.currentUserId,
  });

  // Cache for mutual friends to avoid multiple API calls
  static final Map<String, Future<List<UserModel>>> _mutualFriendsCache = {};
  
  // Cache for network statistics
  static final Map<String, Future<Map<String, int>>> _networkCountsCache = {};

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return _buildProfile(user!);
    } else if (futureUser != null) {
      return FutureBuilder<UserModel?>(
        future: futureUser,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(child: Text(AppLocalizations.of(context)!.errorLoadingData));
          } else if (!userSnapshot.hasData) {
            return Center(child: Text(AppLocalizations.of(context)!.userNotFound));
          }

          // Benutzerdaten erfolgreich geladen
          UserModel user = userSnapshot.data!;
          return _buildProfile(user);
        },
      );
    } else {
      return Center(child: Text(AppLocalizations.of(context)!.noUserDataAvailable));
    }
  }

  /// Formatiert die Mitgliedsdauer basierend auf dem Erstellungsdatum
  String _formatMembershipDuration(BuildContext context, DateTime createdDate) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(createdDate);
    final weeks = difference.inDays ~/ 7;
    final months = difference.inDays ~/ 30;
    final years = difference.inDays ~/ 365;

    if (weeks < 8) {
      return '${l10n.memberSince} $weeks ${weeks == 1 ? l10n.week : l10n.weeks}';
    } else if (months < 12) {
      return '${l10n.memberSince} $months ${months == 1 ? l10n.month : l10n.months}';
    } else {
      return '${l10n.memberSince} $years ${years == 1 ? l10n.year : l10n.years}';
    }
  }

  Widget _buildProfile(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profilbild und Name
          _buildProfileHeader(user),
          // Aktive Informationen
          if (user.description != null && user.description!.isNotEmpty) ...[
            SizedBox(height: 16),
            SelectableText(
              user.description!,
              style: TextStyle(fontSize: 16),
            ),
          ],
          // Stadt mit Ort-Symbol
          if (user.city != null && user.city!.isNotEmpty) ...[
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user.city!,
                    style: TextStyle(fontSize: 16),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ],
          // Phone with phone number
          if (user.telephone != null && user.telephone!.isNotEmpty) ...[
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.phone),
                SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    user.telephone!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
          // Konto seit (berechnet aus created-Datum)
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),
              Builder(
                builder: (context) => Text(
                  _formatMembershipDuration(context, user.created),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          // Anzahl Personen im Netzwerk (nur anzeigen wenn erfolgreich geladen)
          if (user.id != null)
            FutureBuilder<Map<String, int>>(
              future: _getNetworkCounts(user.id!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final directCount = snapshot.data!['direct_count'] ?? 0;
                  final indirectCount = snapshot.data!['indirect_count'] ?? 0;
                  final totalCount = directCount + indirectCount;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.lan),
                          SizedBox(width: 8),
                          Text(
                            '$totalCount ${AppLocalizations.of(context)!.people} ($directCount ${AppLocalizations.of(context)!.direct}, $indirectCount ${AppLocalizations.of(context)!.indirect})',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return SizedBox.shrink(); // Show nothing while loading or on error
              },
            ),
          // Mutual friends (only show if present)
          if (currentUserId != null && user.id != currentUserId)
            FutureBuilder<List<UserModel>>(
              future: _getMutualFriends(currentUserId!, user.id!),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final friendNames = snapshot.data!.map((friend) => friend.firstName).join(', ');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.people),
                          SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!.mutualFriends,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: friendNames,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return SizedBox.shrink(); // Zeige nichts wenn keine gemeinsamen Freunde
              },
            ),
        ],
      ),
    );
  }

  /// Load mutual friends between two users (with cache).
  Future<List<UserModel>> _getMutualFriends(String currentUserId, String profileUserId) {
    final cacheKey = '${currentUserId}_$profileUserId';
    
    // Check cache first
    if (_mutualFriendsCache.containsKey(cacheKey)) {
      return _mutualFriendsCache[cacheKey]!;
    }
    
    // Create new Future and store in cache
    final future = _loadMutualFriends(currentUserId, profileUserId);
    _mutualFriendsCache[cacheKey] = future;
    
    return future;
  }

  /// Actually load mutual friends from the database.
  Future<List<UserModel>> _loadMutualFriends(String currentUserId, String profileUserId) async {
    final friendService = FriendService();
    return await friendService.getMutualFriends(currentUserId, profileUserId);
  }

  /// Load network statistics for a user (with cache).
  Future<Map<String, int>> _getNetworkCounts(String userId) {
    // Check cache first
    if (_networkCountsCache.containsKey(userId)) {
      return _networkCountsCache[userId]!;
    }
    
    // Create new Future and store in cache
    final future = _loadNetworkCounts(userId);
    _networkCountsCache[userId] = future;
    
    return future;
  }

  /// Actually load network statistics from the database.
  Future<Map<String, int>> _loadNetworkCounts(String userId) async {
    final friendService = FriendService();
    return await friendService.getFriendNetworkCounts(userId);
  }

  /// Baut den Profil-Header mit Avatar, Name und Badges
  Widget _buildProfileHeader(UserModel user) {
    if (user.id == null) {
      // Keine User-ID: Name zentriert anzeigen
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarColorUtils.createAvatar(
            name: user.firstName,
            imageUrl: user.imageUrl,
            radius: 40.0,
            iconSize: 40.0,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              user.firstName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    return FutureBuilder<List<BadgeModel>>(
      future: _getUserBadges(user),
      builder: (context, snapshot) {
        final hasBadges = snapshot.hasData && snapshot.data!.isNotEmpty;
        
        return Row(
          crossAxisAlignment: hasBadges 
              ? CrossAxisAlignment.start 
              : CrossAxisAlignment.center,
          children: [
            AvatarColorUtils.createAvatar(
              name: user.firstName,
              imageUrl: user.imageUrl,
              radius: 40.0,
              iconSize: 40.0,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.firstName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasBadges) ...[
                    SizedBox(height: 8),
                    _buildBadgeRow(context, snapshot.data!),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build the badge display for a user.
  Widget _buildBadgeRow(BuildContext context, List<BadgeModel> badges) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 4.0,
      children: badges.map((badge) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BadgeWidget(badge: badge, size: 28.0),
            SizedBox(height: 2),
            Text(
              badge.getTitle(context),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Load and calculate badges for a user.
  Future<List<BadgeModel>> _getUserBadges(UserModel user) async {
    try {
      // Load count of lendables
      int lendableCount = 0;
      try {
        final lendableService = LendableService();
        final lendables = await lendableService.fetchLendablesForPublicProfile(user.id!);
        lendableCount = lendables.length;
      } catch (e) {
        // Ignore error if lendables cannot be loaded
      }
      
      // Lade Anzahl der direkten Freunde
      int friendCount = 0;
      try {
        final networkCounts = await _getNetworkCounts(user.id!);
        friendCount = networkCounts['direct_count'] ?? 0;
      } catch (e) {
        // Ignore error if network statistics cannot be loaded
      }
      
      // Calculate badges automatically by priority
      return BadgeUtils.getBadgesForUser(
        created: user.created,
        lendableCount: lendableCount,
        friendCount: friendCount,
      );
    } catch (e) {
      // On error, show no badges
      return [];
    }
  }

}