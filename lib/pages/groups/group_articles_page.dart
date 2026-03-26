import 'package:flutter/material.dart';
import 'package:verleihapp/components/lendable_list.dart';
import 'package:verleihapp/models/group_model.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/services/lendable_service.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class GroupArticlesPage extends StatefulWidget {
  final GroupModel group;
  final List<GroupMemberModel> members; // Damit wir die Besitzer der Artikel zuordnen können

  const GroupArticlesPage({
    super.key,
    required this.group,
    required this.members,
  });

  @override
  State<GroupArticlesPage> createState() => _GroupArticlesPageState();
}

class _GroupArticlesPageState extends State<GroupArticlesPage> {
  final LendableService _lendableService = LendableService();
  List<Map<LendableModel, UserModel>> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      if (widget.group.id == null) return;
      
      final results = await _lendableService.fetchGroupLendables(widget.group.id!);
      
      if (mounted) {
        setState(() {
          _items = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.groupItems),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadItems,
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    LendableList(
                      lendablesFuture: Future.value(_items),
                      emptyState: _buildEmptyState(l10n),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l10n.noItemsFound,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
