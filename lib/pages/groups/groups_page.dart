import 'package:flutter/material.dart';
import 'package:verleihapp/models/group_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/pages/groups/group_detail_page.dart';
import 'package:verleihapp/pages/groups/create_group_page.dart';
import 'package:verleihapp/pages/groups/join_group_page.dart';
import 'package:verleihapp/services/group_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/utils/icon_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final UserService _userService = UserService();
  final GroupService _groupService = GroupService();
  UserModel? _currentUser;
  bool _isLoading = true;
  List<GroupModel> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final user = await _userService.getCurrentUser();
      if (!mounted) return;
      
      _currentUser = user;
      
      if (_currentUser?.id != null) {
        final groups = await _groupService.getUserGroups(_currentUser!.id!);
        if (!mounted) return;
        _groups = groups;
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, e.toString());
      }
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.groups),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadData,
                child: _groups.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _groups.length,
                        itemBuilder: (context, index) {
                          final group = _groups[index];
                          return _buildGroupCard(group);
                        },
                      ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'groups_page_fab',
        onPressed: _showAddOptions,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        const Icon(Icons.group_outlined, size: 64, color: Colors.grey),
        const SizedBox(height: 16),
        Text(
          l10n.noGroupsYet,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            IconUtils.getIconData(group.icon),
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(group.name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupDetailPage(
                group: group,
              ),
            ),
          ).then((_) => _loadData());
        },
      ),
    );
  }

  void _showAddOptions() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.group_add),
              title: Text(l10n.joinGroup),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JoinGroupPage()),
                ).then((_) => _loadData());
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: Text(l10n.createGroup),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateGroupPage()),
                ).then((_) => _loadData());
              },
            ),
          ],
        ),
      ),
    );
  }
}
