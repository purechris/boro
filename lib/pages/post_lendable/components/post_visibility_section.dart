import 'package:flutter/material.dart';
import 'package:verleihapp/config/constants.dart';
import 'package:verleihapp/models/group_model.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Visibility controls (friends, groups).
class PostVisibilitySection extends StatelessWidget {
  final String? selectedVisibility;
  final String selectedGroupVisibility;
  final List<String> selectedGroupIds;
  final List<GroupModel> userGroups;
  final bool isLoadingGroups;
  final Function(String?) onVisibilityChanged;
  final Function(String?) onGroupVisibilityChanged;
  final Function(String, bool) onGroupSelectionChanged;

  const PostVisibilitySection({
    super.key,
    required this.selectedVisibility,
    required this.selectedGroupVisibility,
    required this.selectedGroupIds,
    required this.userGroups,
    required this.isLoadingGroups,
    required this.onVisibilityChanged,
    required this.onGroupVisibilityChanged,
    required this.onGroupSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildVisibilityControl(context),
        const SizedBox(height: 16),
        _buildGroupVisibilityControl(context),
      ],
    );
  }

  Widget _buildVisibilityControl(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Freunde-Sichtbarkeit",
        border: OutlineInputBorder(),
      ),
      initialValue: selectedVisibility,
      items: [
        DropdownMenuItem<String>(
          value: VisibilityMode.indirectContacts.value,
          child: Row(
            children: [
              const Icon(Icons.groups),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.friendsOfFriends),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: 'direct-contacts',
          child: Row(
            children: [
              const Icon(Icons.group),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.directFriends),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: 'private',
          child: Row(
            children: [
              const Icon(Icons.lock),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.private),
            ],
          ),
        ),
      ],
      onChanged: onVisibilityChanged,
    );
  }

  Widget _buildGroupVisibilityControl(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Gruppen-Sichtbarkeit",
            border: OutlineInputBorder(),
          ),
          initialValue: selectedGroupVisibility,
          items: [
            const DropdownMenuItem(
              value: AppConstants.filterAll,
              child: Row(
                children: [
                  Icon(Icons.groups),
                  SizedBox(width: 8),
                  Text("Alle meine Gruppen"),
                ],
              ),
            ),
            DropdownMenuItem(
              value: VisibilityMode.specific.value,
              child: const Row(
                children: [
                  Icon(Icons.group_add),
                  SizedBox(width: 8),
                  Text("Spezifische Gruppen"),
                ],
              ),
            ),
            const DropdownMenuItem(
              value: 'none',
              child: Row(
                children: [
                  Icon(Icons.lock),
                  SizedBox(width: 8),
                  Text("Keine Gruppen"),
                ],
              ),
            ),
          ],
          onChanged: onGroupVisibilityChanged,
        ),
        if (selectedGroupVisibility == VisibilityMode.specific.value) ...[
          const SizedBox(height: 16),
          _buildSpecificGroupSelector(context),
        ],
      ],
    );
  }

  Widget _buildSpecificGroupSelector(BuildContext context) {
    if (isLoadingGroups) return const Center(child: CircularProgressIndicator());
    if (userGroups.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text("Du bist noch in keiner Gruppe.", style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Wähle die Gruppen aus:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: userGroups.map((group) {
            final isSelected = selectedGroupIds.contains(group.id);
            return FilterChip(
              label: Text(group.name),
              selected: isSelected,
              onSelected: (selected) => onGroupSelectionChanged(group.id!, selected),
            );
          }).toList(),
        ),
      ],
    );
  }
}
