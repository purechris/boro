import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/models/group_model.dart';
import 'package:verleihapp/services/group_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/utils/icon_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';

class CreateGroupPage extends StatefulWidget {
  final GroupModel? group;

  const CreateGroupPage({
    super.key,
    this.group,
  });

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _groupService = GroupService();
  final _userService = UserService();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late IconData _selectedIcon;
  bool _isLoading = false;

  bool get _isEditing => widget.group != null;

  final List<IconData> _availableIcons = IconUtils.availableIcons;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group?.name);
    _descriptionController = TextEditingController(text: widget.group?.description);
    
    // Icon wiederherstellen oder Standard setzen
    if (_isEditing && widget.group?.icon != null) {
      _selectedIcon = _availableIcons.firstWhere(
        (icon) => icon.codePoint.toString() == widget.group!.icon,
        orElse: () => Icons.groups,
      );
    } else {
      _selectedIcon = Icons.groups;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editGroup : l10n.createGroup),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              l10n.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: l10n.groupName,
                border: const OutlineInputBorder(),
              ),
              maxLength: 20,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.groupDescription,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: l10n.groupDescription,
                border: const OutlineInputBorder(),
              ),
              maxLines: null,
              minLines: 3,
              maxLength: 1000,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.selectIcon,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 70,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: _availableIcons.length,
              itemBuilder: (context, index) {
                final icon = _availableIcons[index];
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                          : null,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                      size: 30,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _userService.isDemoUser() ? null : (_isLoading ? null : _handleSave),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(_isEditing ? l10n.save : l10n.create),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      SnackbarUtils.showError(context, l10n.groupNameRequired);
      return;
    }
    if (name.length > 20) {
      SnackbarUtils.showError(context, l10n.groupNameTooLong);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        await _groupService.updateGroup(
          groupId: widget.group!.id!,
          name: name,
          description: _descriptionController.text.trim(),
          icon: _selectedIcon.codePoint.toString(),
        );
        if (mounted) {
          SnackbarUtils.showSuccess(context, l10n.groupUpdatedSuccess);
        }
      } else {
        await _groupService.createGroup(
          name: name,
          description: _descriptionController.text.trim(),
          icon: _selectedIcon.codePoint.toString(),
        );
        if (mounted) {
          SnackbarUtils.showSuccess(context, l10n.groupCreated);
        }
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
