import 'package:flutter/material.dart';
import 'package:verleihapp/components/user_card.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/models/friend_list_data.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Tab displaying the list of friends.
class FriendListTab extends StatelessWidget {
  final Future<FriendListData> dataFuture;
  final bool isDemoUser;
  final Function(UserModel) onRemoveFriend;
  final Function(UserModel) onNavigateToProfile;
  final VoidCallback onAddFriendsNow;
  final RefreshCallback? onRefresh;

  const FriendListTab({
    super.key,
    required this.dataFuture,
    required this.isDemoUser,
    required this.onRemoveFriend,
    required this.onNavigateToProfile,
    required this.onAddFriendsNow,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final refreshIndicator = onRefresh != null 
      ? (Widget child) => RefreshIndicator(onRefresh: onRefresh!, child: child)
      : (Widget child) => child;

    return FutureBuilder<FriendListData>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return refreshIndicator(
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text(AppLocalizations.of(context)!.errorLoadingData)),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final friends = snapshot.data!.friends;
          if (friends.isEmpty) {
            return refreshIndicator(
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: _buildEmptyState(context),
                ),
              ),
            );
          }
          return refreshIndicator(
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFriendList(context, friends),
                  ],
                ),
              ),
            ),
          );
        }
        return refreshIndicator(
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(child: Text(AppLocalizations.of(context)!.noDataFound)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendList(BuildContext context, List<UserModel> friends) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return UserCard(
          user: friend,
          onTap: () => onNavigateToProfile(friend),
          rightWidget: _buildFriendMenu(context, friend),
        );
      },
    );
  }

  Widget _buildFriendMenu(BuildContext context, UserModel friend) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      enabled: !isDemoUser,
      onSelected: (value) {
        if (value == 'delete') {
          onRemoveFriend(friend);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, color: Colors.red),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.removeFriend),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.shareFriendCodeText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAddFriendsNow,
              icon: const Icon(Icons.person_add),
              label: Text(AppLocalizations.of(context)!.addFriendsNow),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
