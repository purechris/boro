import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/pages/settings/settings.dart';
import 'package:verleihapp/pages/settings/edit_profile.dart';
import 'package:verleihapp/pages/post_lendable/post_lendable.dart';
import 'package:flutter/material.dart';
import 'package:verleihapp/services/lendable_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/components/lendable_list.dart';
import 'package:verleihapp/components/profile_card.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class PrivateProfilePage extends StatefulWidget {
  const PrivateProfilePage({super.key});

  @override
  State<PrivateProfilePage> createState() => _PrivateProfilePageState();
}

class _PrivateProfilePageState extends State<PrivateProfilePage> {
  // Services
  final LendableService _lendableService = LendableService();
  final UserService _userService = UserService();

  // UI constants
  static const double _spacing = 20.0;

  // State
  late Future<UserModel?> _currentUser;
  late Future<List<Map<LendableModel, UserModel>>> _lendablesWithUsers;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _lendablesWithUsers = _lendableService.getLendablesForPrivateProfile();
      _currentUser = _userService.getCurrentUser();
    });
  }

  void _onDelete(bool success, String? error) {
    if (success) {
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.articleDeletedSuccess);
      _loadData();
    } else {
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
    }
  }

  /// Check if the profile is incomplete.
  bool _isProfileIncomplete(UserModel user) {
    // Check for missing fields
    if (user.imageUrl == null || user.imageUrl!.isEmpty) {
      return true;
    }
    if (user.description == null || user.description!.isEmpty) {
      return true;
    }
    if (user.city == null || user.city!.isEmpty) {
      return true;
    }
    if (user.telephone == null || user.telephone!.isEmpty) {
      return true;
    }
    
    return false;
  }

  void _navigateToEditProfile() {
    NavigationUtils.navigateTo(context, const EditProfilePage());
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

  Widget _buildProfileCompletionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.edit,
                size: 18.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.profileIncomplete,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Center(
            child: ElevatedButton.icon(
              onPressed: _navigateToEditProfile,
              label: Text(AppLocalizations.of(context)!.profileEdit),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.addFirstItems,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PostLendablePage()),
                );
              },
              icon: const Icon(Icons.add_circle),
              label: Text(AppLocalizations.of(context)!.lendNow),
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

  Widget _buildProfileHeader() {
    return FutureBuilder<UserModel?>(
      future: _currentUser,
      builder: (context, userSnapshot) {
        return Column(
          children: [
            ProfileCard(
              futureUser: _currentUser,
              currentUserId: userSnapshot.data?.id,
            ),
            SizedBox(height: _spacing),
            if (userSnapshot.hasData && userSnapshot.data != null) ...[
              if (_isProfileIncomplete(userSnapshot.data!))
                _buildProfileCompletionCard(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: FutureBuilder<List<Map<LendableModel, UserModel>>>(
        future: _lendablesWithUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                _buildProfileHeader(),
                Expanded(
                  child: _buildEmptyState(),
                ),
              ],
            );
          }

          return ListView(
            children: [
              _buildProfileHeader(),
              SizedBox(height: _spacing),
              LendableList(
                lendablesFuture: _lendablesWithUsers,
                title: AppLocalizations.of(context)!.myAds,
                showMenu: true,
                onDelete: _onDelete,
                onBorrowChanged: _loadData,
                hideUserName: true,
              ),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.myProfile),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _navigateToEditProfile,
          tooltip: AppLocalizations.of(context)!.editProfileTooltip,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _navigateToSettings(),
          tooltip: AppLocalizations.of(context)!.settingsTooltip,
        ),
      ],
    );
  }

  void _navigateToSettings() {
    NavigationUtils.navigateTo(context, const SettingsPage());
  }
}