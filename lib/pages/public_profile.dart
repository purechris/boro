import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:verleihapp/services/lendable_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/services/friend_service.dart';
import 'package:verleihapp/components/lendable_list.dart';
import 'package:verleihapp/components/profile_card.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class PublicProfilePage extends StatefulWidget {
  final String userId;

  const PublicProfilePage({super.key, required this.userId});

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  // Services
  final LendableService _lendableService = LendableService();
  final UserService _userService = UserService();
  final FriendService _friendService = FriendService();

  // UI constants
  static const double _spacing = 20.0;

  // State
  late Future<UserModel?> _userFuture;
  late Future<List<Map<LendableModel, UserModel>>> _lendablesWithUsers;
  
  // Key for the FutureBuilder to reload it after sending a request
  Key _friendStatusKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _userFuture = _userService.getUser(widget.userId);
    _lendablesWithUsers = _lendableService.fetchLendablesForPublicProfile(widget.userId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noAdsYet,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.userHasNoAds,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<UserModel?>(
      future: _userFuture,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userSnapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.profileLoadError,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.userCouldNotBeLoaded,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!userSnapshot.hasData || userSnapshot.data == null) {
          return Center(
            child: Text(AppLocalizations.of(context)!.userNotFound),
          );
        }

        final user = userSnapshot.data!;
        return FutureBuilder<List<Map<LendableModel, UserModel>>>(
          future: _lendablesWithUsers,
          builder: (context, lendablesSnapshot) {
            return ListView(
              children: [
                FutureBuilder<UserModel?>(
                  future: _userService.getCurrentUser(),
                  builder: (context, currentUserSnapshot) {
                    final currentUserId = currentUserSnapshot.data?.id;
                    return Column(
                      children: [
                        ProfileCard(
                          user: user,
                          currentUserId: currentUserId,
                        ),
                        // Freundschafts-Button (nur wenn nicht eigenes Profil)
                        if (currentUserId != null && currentUserId != user.id)
                          _buildFriendButton(currentUserId, user.id!),
                      ],
                    );
                  },
                ),
                const SizedBox(height: _spacing),
                if (lendablesSnapshot.connectionState == ConnectionState.waiting)
                  const Center(child: CircularProgressIndicator())
                else if (!lendablesSnapshot.hasData || lendablesSnapshot.data!.isEmpty)
                  _buildEmptyState()
                else
                  LendableList(
                    lendablesFuture: _lendablesWithUsers,
                    title: AppLocalizations.of(context)!.currentAds,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  /// Baut den Freundschafts-Button
  Widget _buildFriendButton(String currentUserId, String profileUserId) {
    return FutureBuilder<Map<String, bool>>(
      key: _friendStatusKey,
      future: _getFriendStatus(currentUserId, profileUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                label: Text(AppLocalizations.of(context)!.loading),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              ),
            ),
          );
        }

        final isFriend = snapshot.hasData && snapshot.data!['isFriend'] == true;
        final hasPending = snapshot.hasData && snapshot.data!['hasPending'] == true;
        
        // Button-Konfiguration basierend auf Status
        IconData icon;
        String label;
        Color? backgroundColor;
        Color? foregroundColor;
        bool isEnabled;
        
        if (isFriend) {
          icon = Icons.check_circle;
          label = AppLocalizations.of(context)!.friend;
          backgroundColor = Colors.grey[300];
          foregroundColor = Colors.grey[700];
          isEnabled = false;
        } else if (hasPending) {
          icon = Icons.hourglass_empty;
          label = AppLocalizations.of(context)!.requestPending;
          backgroundColor = Colors.blue[50];
          foregroundColor = Colors.blue[700];
          isEnabled = false;
        } else {
          icon = Icons.person_add;
          label = AppLocalizations.of(context)!.addAsFriend;
          backgroundColor = Theme.of(context).colorScheme.primary;
          foregroundColor = Theme.of(context).colorScheme.onPrimary;
          isEnabled = true;
        }
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: isEnabled ? () => _sendFriendRequest(currentUserId, profileUserId) : null,
              icon: Icon(icon),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                disabledBackgroundColor: backgroundColor,
                disabledForegroundColor: foregroundColor,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Load friendship status (are friends and pending request status).
  Future<Map<String, bool>> _getFriendStatus(String currentUserId, String profileUserId) async {
    final isFriend = await _friendService.areFriends(currentUserId, profileUserId);
    final hasPending = await _friendService.hasPendingRequest(currentUserId, profileUserId);
    
    return {
      'isFriend': isFriend,
      'hasPending': hasPending,
    };
  }

  /// Send a friend request.
  Future<void> _sendFriendRequest(String currentUserId, String profileUserId) async {
    try {
      await _friendService.createFriendRequest(currentUserId, profileUserId);
      if (!mounted) return;
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.requestSent);
      setState(() {
        _friendStatusKey = UniqueKey();
      });
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.profile),
      centerTitle: true,
    );
  }
}