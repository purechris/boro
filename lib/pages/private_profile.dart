import 'package:verleihapp/config/constants.dart';
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
import 'package:verleihapp/components/error_state_widget.dart';
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
  List<Map<LendableModel, UserModel>> _lendables = [];
  bool _isLoadingLendables = true;
  bool _hasLendablesError = false;
  String _sorting = SortingMode.newest.value;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _currentUser = _userService.getCurrentUser();
      _isLoadingLendables = true;
      _hasLendablesError = false;
    });
    try {
      final results = await _lendableService.getLendablesForPrivateProfile();
      if (mounted) {
        setState(() {
          _lendables = results;
          _isLoadingLendables = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLendables = false;
          _hasLendablesError = true;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    ProfileCard.clearCache();
    await _loadData();
  }

  void _onDelete(bool success, String? error, String lendableId) {
    if (success) {
      setState(() {
        _lendables.removeWhere((map) => map.keys.first.id == lendableId);
      });
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.articleDeletedSuccess);
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const EditProfilePage()))
        .then((_) {
      if (!mounted) return;
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'private_profile_fab',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PostLendablePage()),
          ).then((_) => _loadData());
        },
        tooltip: AppLocalizations.of(context)!.navLend,
        child: const Icon(Icons.add),
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
      onRefresh: _refreshData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: _buildSlivers(),
      ),
    );
  }

  List<Widget> _buildSlivers() {
    if (_isLoadingLendables) {
      return [const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))];
    }
    if (_hasLendablesError) {
      return [
        SliverToBoxAdapter(child: _buildProfileHeader()),
        SliverFillRemaining(child: ErrorStateWidget(onRetry: _loadData)),
      ];
    }
    if (_lendables.isEmpty) {
      return [
        SliverToBoxAdapter(child: _buildProfileHeader()),
        SliverFillRemaining(child: _buildEmptyState()),
      ];
    }
    final sortedLendables = _sortLendables(_lendables);
    return [
      SliverToBoxAdapter(child: _buildProfileHeader()),
      SliverToBoxAdapter(child: SizedBox(height: _spacing)),
      SliverToBoxAdapter(child: _buildListHeader(context, sortedLendables.length)),
      const SliverToBoxAdapter(child: SizedBox(height: 15)),
      SliverToBoxAdapter(
        child: LendableList(
          lendables: sortedLendables,
          showMenu: true,
          onDelete: _onDelete,
          onBorrowChanged: _loadData,
          hideUserName: true,
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 96)),
    ];
  }

  List<Map<LendableModel, UserModel>> _sortLendables(
      List<Map<LendableModel, UserModel>> items) {
    final sorted = List<Map<LendableModel, UserModel>>.from(items);
    if (_sorting == SortingMode.newest.value) {
      sorted.sort(
          (a, b) => b.keys.first.created.compareTo(a.keys.first.created));
    } else if (_sorting == SortingMode.oldest.value) {
      sorted.sort(
          (a, b) => a.keys.first.created.compareTo(b.keys.first.created));
    } else if (_sorting == SortingMode.alphabetical.value) {
      sorted.sort((a, b) => a.keys.first.title
          .toLowerCase()
          .compareTo(b.keys.first.title.toLowerCase()));
    } else if (_sorting == SortingMode.borrowedFirst.value) {
      sorted.sort((a, b) {
        final borrowedCompare = (b.keys.first.isBorrowed ? 1 : 0) -
            (a.keys.first.isBorrowed ? 1 : 0);
        if (borrowedCompare != 0) return borrowedCompare;
        return b.keys.first.created.compareTo(a.keys.first.created);
      });
    }
    return sorted;
  }

  Widget _buildListHeader(BuildContext context, int count) {
    final l10n = AppLocalizations.of(context)!;
    final bool isActive = _sorting != SortingMode.newest.value;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 8),
      child: Row(
        children: [
          Text(
            '${l10n.myAds} ($count)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.sort,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            tooltip: l10n.sorting,
            onPressed: () => _showSortingBottomSheet(context),
          ),
        ],
      ),
    );
  }

  void _showSortingBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RadioGroup<String>(
                groupValue: _sorting,
                onChanged: (val) {
                  if (val == null) return;
                  setState(() => _sorting = val);
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        l10n.sorting,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(l10n.newest),
                      leading: Radio<String>(
                        value: SortingMode.newest.value,
                      ),
                      onTap: () {
                        setState(() => _sorting = SortingMode.newest.value);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(l10n.oldest),
                      leading: Radio<String>(
                        value: SortingMode.oldest.value,
                      ),
                      onTap: () {
                        setState(() => _sorting = SortingMode.oldest.value);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(l10n.alphabetical),
                      leading: Radio<String>(
                        value: SortingMode.alphabetical.value,
                      ),
                      onTap: () {
                        setState(
                            () => _sorting = SortingMode.alphabetical.value);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(l10n.borrowedFirst),
                      leading: Radio<String>(
                        value: SortingMode.borrowedFirst.value,
                      ),
                      onTap: () {
                        setState(
                            () => _sorting = SortingMode.borrowedFirst.value);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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