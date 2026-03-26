import 'package:flutter/material.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/pages/lendable.dart';
import 'package:verleihapp/pages/post_lendable/post_lendable.dart';
import 'package:verleihapp/services/lendable_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/components/lazy_image_widget.dart';

class LendableCard extends StatelessWidget {
  final LendableModel lendable;
  final UserModel user;
  final bool showMenu;
  final bool hideUserName;
  final void Function(bool success, String? error)? onDelete;
  final VoidCallback? onBorrowChanged;
  final VoidCallback? onReturnFromDetail;

  // UI-Konstanten
  static const double _imageWidth = 120.0;
  static const double _imageHeight = 100.0;
  static const double _placeholderIconSize = 32.0;
  static const double _spacing = 6.0;
  static const double _titleFontSize = 16.0;
  static const double _subtitleFontSize = 13.0;
  static const Color _placeholderGradientStart = Color(0xFFE0E0E0);
  static const Color _placeholderGradientEnd = Color(0xFFF5F5F5);
  static const Color _placeholderIconColor = Color(0xFF9E9E9E);
  static const Color _typeLendColor = Color(0xFF2196F3); // Blue for "to lend"
  static const Color _typeGiveColor = Color(0xFF4CAF50); // Green for "to give"
  static const Color _typeSearchColor = Color(0xFFFF9800); // Orange for "wanted"
  static const Color _typeSellColor = Color(0xFF009688); // Teal for "to sell"
  static const int _maxBorrowerNameLength = 24;

  const LendableCard({
    super.key,
    required this.lendable,
    required this.user,
    this.showMenu = false,
    this.hideUserName = false,
    this.onDelete,
    this.onBorrowChanged,
    this.onReturnFromDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () => _navigateToLendable(context),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTitle(context),
                      const SizedBox(height: _spacing),
                      if (!hideUserName)
                        _buildIconInfo(context, Icons.person_outline, user.firstName),
                      const SizedBox(height: 2),
                      _buildLocationInfo(context),
                      const SizedBox(height: _spacing),
                      _buildTypeBadge(context),
                      if (showMenu && lendable.isBorrowed) ...[
                        const SizedBox(height: 6),
                        _buildBorrowedInfoRow(context),
                      ],
                    ],
                  ),
                ),
              ),
              if (showMenu) _buildMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final hasImageUrl = lendable.imageUrl.isNotEmpty;
    final isNew = DateTime.now().difference(lendable.created).inDays <= 14;
    final isBorrowed = lendable.isBorrowed;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: hasImageUrl
              ? LazyImageWidget(
                  imageUrl: lendable.imageUrl,
                  width: _imageWidth,
                  height: _imageHeight,
                  fit: BoxFit.cover,
                  placeholder: _buildPlaceholder(context),
                  cacheWidth: _imageWidth.toInt() * 2, // Für Schärfe auf Retina-Displays
                  cacheHeight: _imageHeight.toInt() * 2,
                )
              : SizedBox(
                  width: _imageWidth,
                  height: _imageHeight,
                  child: _buildPlaceholder(context),
                ),
        ),
        if (isBorrowed)
          Positioned(
            top: 6,
            left: 6,
            child: _buildBorrowedBadge(context),
          )
        else if (isNew)
          Positioned(
            top: 6,
            left: 6,
            child: _buildNewBadge(context),
          ),
      ],
    );
  }

  Widget _buildBorrowedBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        AppLocalizations.of(context)!.borrowedBadge,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNewBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        AppLocalizations.of(context)!.newBadge,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_placeholderGradientStart, _placeholderGradientEnd],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: _placeholderIconSize,
          color: _placeholderIconColor,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      lendable.title,
      style: const TextStyle(
        fontSize: _titleFontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildIconInfo(BuildContext context, IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: _subtitleFontSize),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    // Standort des Artikels als Standard, User-Stadt als Fallback
    final location = (lendable.city.isNotEmpty) ? lendable.city : (user.city ?? '');
    return _buildIconInfo(context, Icons.place_outlined, location);
  }

  Widget _buildTypeBadge(BuildContext context) {
    final typeCard = lendable.getDisplayedTypeCard(context);
    final isLend = lendable.type == 'offer';
    final isSearch = lendable.type == 'search';
    final isSell = lendable.type == 'sell';
    
    final typeColor = isSell ? _typeSellColor : (isSearch ? _typeSearchColor : (isLend ? _typeLendColor : _typeGiveColor));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: typeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        typeCard.toUpperCase(),
        style: TextStyle(
          color: typeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBorrowedInfoRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = _clampBorrowerName((lendable.borrowedBy ?? '').trim());

    return Row(
      children: [
        Icon(
          Icons.folder_shared,
          size: 16,
          color: scheme.tertiary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: scheme.tertiary,
              fontSize: _subtitleFontSize,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _clampBorrowerName(String name) {
    if (name.length <= _maxBorrowerNameLength) return name;
    return '${name.substring(0, _maxBorrowerNameLength)}…';
  }

  Widget _buildMenu(BuildContext context) {
    final userService = UserService();
    final isDemoUser = userService.isDemoUser();
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      enabled: !isDemoUser,
      onSelected: (value) async {
        if (value == 'edit') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostLendablePage(lendable: lendable),
            ),
          );
        } else if (value == 'lend_to') {
          await _showLendToDialog(context);
        } else if (value == 'retrieve') {
          await _showRetrieveConfirmationDialog(context);
        } else if (value == 'delete') {
          _showDeleteConfirmationDialog(context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit, size: 18),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.edit),
            ],
          ),
        ),
        PopupMenuItem(
          value: lendable.isBorrowed ? 'retrieve' : 'lend_to',
          child: Row(
            children: [
              Icon(
                lendable.isBorrowed ? Icons.move_to_inbox : Icons.person_add_alt_1,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                lendable.isBorrowed
                    ? AppLocalizations.of(context)!.retrieveItem
                    : AppLocalizations.of(context)!.lendTo,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showLendToDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: '');
    final lendableService = LendableService();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.lendToTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            maxLength: _maxBorrowerNameLength,
            decoration: InputDecoration(
              hintText: l10n.lendToHint,
            ),
            onSubmitted: (_) async {
              final name = controller.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text(l10n.enterBorrowerName)),
                );
                return;
              }
              Navigator.of(dialogContext).pop();
              await lendableService.setBorrowedBy(lendable.id, name);
              onBorrowChanged?.call();
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(l10n.save),
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.enterBorrowerName)),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop();
                await lendableService.setBorrowedBy(lendable.id, name);
                onBorrowChanged?.call();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRetrieveConfirmationDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final lendableService = LendableService();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.retrieveItemQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.retrieveItem),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await lendableService.setBorrowedBy(lendable.id, null);
      onBorrowChanged?.call();
    }
  }

  void _navigateToLendable(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LendablePage(
          lendableId: lendable.id,
        ),
      ),
    );
    onReturnFromDetail?.call();
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.articleDelete),
          content: Text(AppLocalizations.of(context)!.deleteArticleConfirm),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteLendable(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLendable(BuildContext context) async {
    final LendableService lendableService = LendableService();
    try {
      await lendableService.deleteLendable(lendable.id);
      onDelete?.call(true, null);
    } catch (e) {
      onDelete?.call(false, null);
    }
  }
}
