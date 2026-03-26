import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verleihapp/components/user_card.dart';
import 'package:verleihapp/models/group_model.dart';
import 'package:verleihapp/pages/groups/group_articles_page.dart';
import 'package:verleihapp/pages/groups/create_group_page.dart';
import 'package:verleihapp/pages/public_profile.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/services/group_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/utils/icon_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';

class GroupDetailPage extends StatefulWidget {
  final GroupModel group;

  const GroupDetailPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final GroupService _groupService = GroupService();
  final UserService _userService = UserService();
  late GroupModel _group;
  List<GroupMemberModel> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final userId = _userService.getCurrentUserId();
      
      // 1. Fetch updated group details
      final updatedGroup = await _groupService.getGroup(_group.id!, userId);
      if (updatedGroup != null) {
        _group = updatedGroup;
      }

      // 2. Fetch members (including roles)
      final members = await _groupService.getGroupMembers(_group.id!);
      
      if (!mounted) return;
      setState(() {
        _members = members;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isAdmin = _group.isAdmin;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
          // 1. Header mit SliverAppBar
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            iconTheme: IconThemeData(color: colorScheme.primary),
            actions: [
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateGroupPage(group: _group),
                      ),
                    );
                    if (result == true) {
                      _loadData();
                    }
                  },
                  tooltip: l10n.edit,
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _group.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              centerTitle: true,
              background: Container(
                color: colorScheme.primary.withValues(alpha: 0.1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Icon(
                      IconUtils.getIconData(_group.icon),
                      size: 80,
                      color: colorScheme.primary.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card (Beschreibung & Code)
                  _buildQuickInfoCard(l10n, colorScheme),
                  
                  const SizedBox(height: 32),
                  
                  // Artikel Sektion
                  _buildSectionHeader(l10n.groupItems, Icons.inventory_2_outlined),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupArticlesPage(
                            group: _group,
                            members: _members,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Alle Artikel ansehen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                      foregroundColor: colorScheme.primary,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Mitglieder Sektion
                  _buildSectionHeader(l10n.members, Icons.people_outline),
                  const SizedBox(height: 12),
                  _buildMembersList(l10n),
                  
                  const SizedBox(height: 48),
                  
                  // Gefahrenzone
                  _buildDangerZone(l10n),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInfoCard(AppLocalizations l10n, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_group.description != null && _group.description!.isNotEmpty) ...[
              Text(
                _group.description!,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.groupCode, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(
                      _userService.isDemoUser() ? '###-###' : _group.groupCode,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _userService.isDemoUser() ? null : _copyGroupCode,
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: l10n.copy,
                    ),
                    if (_group.isAdmin && !_userService.isDemoUser()) ...[
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _renewGroupCode,
                        icon: const Icon(Icons.refresh, size: 20),
                        tooltip: l10n.renewGroupCode,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(AppLocalizations l10n) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_members.isEmpty) return Text(l10n.noMembers, style: const TextStyle(color: Colors.grey));

    return Column(
      children: _members.map((member) {
        if (member.user == null) return const SizedBox.shrink();
        
        final isMemberAdmin = member.role == 'admin';
        return UserCard(
          user: member.user!,
          onTap: () => _navigateToPublicProfile(member.userId),
          rightWidget: _group.isAdmin && !isMemberAdmin
              ? _buildMemberMenu(member)
              : isMemberAdmin ? _buildAdminBadge() : null,
        );
      }).toList(),
    );
  }

  void _navigateToPublicProfile(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublicProfilePage(userId: userId),
      ),
    );
  }

  Widget _buildAdminBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        AppLocalizations.of(context)!.admin,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildMemberMenu(GroupMemberModel member) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'make_admin') { _makeAdmin(member); }
        else if (value == 'remove') { _removeMember(member); }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'make_admin',
          child: Row(children: [const Icon(Icons.admin_panel_settings, color: Colors.blue), const SizedBox(width: 8), Text(l10n.makeAdmin)]),
        ),
        PopupMenuItem(
          value: 'remove',
          child: Row(children: [const Icon(Icons.person_remove, color: Colors.red), const SizedBox(width: 8), Text(l10n.removeMember)]),
        ),
      ],
    );
  }

  Widget _buildDangerZone(AppLocalizations l10n) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: _userService.isDemoUser() ? null : _leaveGroup,
          icon: const Icon(Icons.exit_to_app),
          label: Text(l10n.leaveGroup),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_group.isAdmin) ...[
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _userService.isDemoUser() ? null : _deleteGroup,
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.deleteGroup),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red,
              elevation: 0,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _copyGroupCode() async {
    try {
      await Clipboard.setData(ClipboardData(text: _group.groupCode));
      if (!mounted) return;
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.groupCodeCopied);
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
    }
  }

  Future<void> _renewGroupCode() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.renewGroupCode),
        content: Text(
          AppLocalizations.of(context)!.renewGroupCodeConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            child: const Text('Erneuern'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _groupService.renewGroupCode(_group.id!);
        if (!mounted) return;
        
        SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.groupCodeRenewed);
        _loadData(); // Neuladen, um den neuen Code anzuzeigen
      } catch (e) {
        if (!mounted) return;
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
  }

  Future<void> _makeAdmin(GroupMemberModel member) async {
    try {
      await _groupService.updateMemberRole(_group.id!, member.userId, 'admin');
      if (!mounted) return;
      
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.adminChanged);
      _loadData();
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
    }
  }

  Future<void> _removeMember(GroupMemberModel member) async {
    final confirm = await _showConfirmDialog(
      AppLocalizations.of(context)!.removeMemberTitle,
      AppLocalizations.of(context)!.removeMemberConfirm,
    );
    if (confirm) {
      try {
        await _groupService.removeMember(_group.id!, member.userId);
        if (!mounted) return;
        
        SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.memberRemoved);
        _loadData();
      } catch (e) {
        if (!mounted) return;
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
  }

  Future<void> _leaveGroup() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await _showConfirmDialog(
      l10n.leaveGroupTitle,
      l10n.leaveGroupConfirm,
      confirmText: l10n.leave,
    );
    if (confirm) {
      try {
        final userId = _userService.getCurrentUserId();
        await _groupService.removeMember(_group.id!, userId);
        if (!mounted) return;
        
        SnackbarUtils.showSuccess(context, l10n.leaveGroupSuccess);
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
  }

  Future<void> _deleteGroup() async {
    final confirm = await _showConfirmDialog(
      AppLocalizations.of(context)!.deleteGroupTitle,
      AppLocalizations.of(context)!.deleteGroupConfirm,
    );
    if (confirm) {
      try {
        await _groupService.deleteGroup(_group.id!);
        if (!mounted) return;
        
        SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.groupDeleted);
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
  }

  Future<bool> _showConfirmDialog(
    String title,
    String content, {
    String? confirmText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText ?? AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
