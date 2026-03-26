import 'package:flutter/material.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/models/category_model.dart';
import 'package:verleihapp/pages/public_profile.dart';
import 'package:verleihapp/services/favorite_service.dart';
import 'package:verleihapp/services/lendable_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/components/user_card.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Detail page for a single lendable item.
/// Shows all item information and allows adding to favorites.
class LendablePage extends StatefulWidget {
  final String lendableId;

  const LendablePage({
    super.key,
    required this.lendableId,
  });

  @override
  State<LendablePage> createState() => _LendablePageState();
}

class _LendablePageState extends State<LendablePage> {
  // Services
  final FavoriteService _favoriteService = FavoriteService();
  final LendableService _lendableService = LendableService();
  final UserService _userService = UserService();

  // UI constants
  static const double _imageMinHeight = 230.0;
  static const double _imageMaxHeight = 450.0;
  static const double _imageErrorIconSize = 60.0;
  static const double _padding = 16.0;
  static const double _spacing = 8.0;
  static const double _titleFontSize = 20.0;
  static const double _sectionTitleFontSize = 16.0;
  static const double _descriptionFontSize = 14.0;
  static const double _errorTextFontSize = 16.0;

  static const Color _errorBackgroundColor = Color(0xFFF5F5F5);
  static const Color _errorTextColor = Color(0xFF757575);

  // State
  late Future<LendableModel> _lendableFuture;
  late Future<UserModel?> _userFuture;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _lendableFuture = _lendableService.getLendable(widget.lendableId);
    _lendableFuture.then((lendable) {
      _userFuture = _userService.getUser(lendable.userId);
      _checkIfFavorite();
    });
  }

  Future<void> _checkIfFavorite() async {
    try {
      final isReallyFavorite = await _favoriteService.checkIfFavorite(widget.lendableId);
      setState(() => _isFavorite = isReallyFavorite);
    } catch (_) {
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await _favoriteService.removeFavorite(widget.lendableId);
        setState(() => _isFavorite = !_isFavorite);
        if (mounted) {
          SnackbarUtils.showInfo(
            context,
            AppLocalizations.of(context)!.articleRemovedFromFavorites,
          );
        }
      } else {
        await _favoriteService.addFavorite(widget.lendableId);
        setState(() => _isFavorite = !_isFavorite);
        if (mounted) {
          SnackbarUtils.showInfo(
            context,
            AppLocalizations.of(context)!.articleAddedToFavorites,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(
          context,
          AppLocalizations.of(context)!.errorOccurred,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        bottom: true, // Explicitly handle bottom for transparent navigation bar
        child: FutureBuilder<LendableModel>(
        future: _lendableFuture,
        builder: (context, lendableSnapshot) {
          if (lendableSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (lendableSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.errorLoadingArticle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.articleCouldNotBeLoaded,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!lendableSnapshot.hasData || lendableSnapshot.data == null) {
            return Center(
              child: Text(AppLocalizations.of(context)!.articleNotFound),
            );
          }

          final lendable = lendableSnapshot.data!;
          return FutureBuilder<UserModel?>(
            future: _userFuture,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError || !userSnapshot.hasData || userSnapshot.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.errorLoadingData,
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

              final user = userSnapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(lendable),
                    _buildTitleWithCity(lendable),
                    _buildUserCard(user),
                    _buildArticleInformation(lendable, user),
                  ],
                ),
              );
            },
          );
        },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Details'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: _userService.isDemoUser() ? null : _toggleFavorite,
        ),
      ],
    );
  }

  Widget _buildImageSection(LendableModel lendable) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: _imageMinHeight,
        maxHeight: _imageMaxHeight,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: _buildImage(lendable),
      ),
    );
  }

  Widget _buildImage(LendableModel lendable) {
    if (lendable.imageUrl.isEmpty) {
      return _buildImageError();
    }

    return Image.network(
      lendable.imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildImageError(),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: _errorBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: _imageErrorIconSize,
              color: _errorTextColor,
            ),
            SizedBox(height: _spacing),
            Text(
              AppLocalizations.of(context)!.noImageAvailable,
              style: TextStyle(
                fontSize: _errorTextFontSize,
                color: _errorTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWithCity(LendableModel lendable) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            lendable.title,
            style: const TextStyle(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _padding),
      child: UserCard(
        user: user,
        onTap: () => _navigateToPublicProfile(user),
      ),
    );
  }

  Widget _buildArticleInformation(LendableModel lendable, UserModel user) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppLocalizations.of(context)!.details),
          SizedBox(height: _spacing),
          _buildDetailRow(AppLocalizations.of(context)!.categoryLabel, CategoryModel.getLocalizedNameForCategory(context, lendable.category)),
          SizedBox(height: _spacing),
          _buildDetailRow(AppLocalizations.of(context)!.offerTypeLabel, lendable.getDisplayedTypeCard(context)),
          SizedBox(height: _spacing),
          _buildDetailRow(AppLocalizations.of(context)!.articleLocationLabel, _getDisplayLocation(lendable, user)),
          SizedBox(height: _spacing),
          _buildVisibilityRow(lendable),
          SizedBox(height: _spacing),
          _buildDetailRow(AppLocalizations.of(context)!.postedOnLabel, _formatDate(lendable.created)),
          const Divider(),
          _buildSectionTitle(AppLocalizations.of(context)!.description),
          SizedBox(height: _spacing),
          SelectableText(
            lendable.description.isNotEmpty 
                ? lendable.description 
                : AppLocalizations.of(context)!.noDescriptionAvailable,
            style: TextStyle(
              fontSize: _descriptionFontSize,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: _padding),
        ],
      ),
    );
  }

  String _getDisplayLocation(LendableModel lendable, UserModel user) {
    if (lendable.city.isNotEmpty) {
      return lendable.city;
    }
    if (user.city != null && user.city!.isNotEmpty) {
      return user.city!;
    }
    return '-';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: _sectionTitleFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }

  Widget _buildVisibilityRow(LendableModel lendable) {
    IconData visibilityIcon;
    
    switch (lendable.visibility) {
      case 'indirect-contacts':
        visibilityIcon = Icons.groups; // Three people for friends of friends
        break;
      case 'direct-contacts':
        visibilityIcon = Icons.group; // Two people for direct friends
        break;
      case 'private':
        visibilityIcon = Icons.lock; // Lock for private
        break;
      default:
        visibilityIcon = Icons.groups;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppLocalizations.of(context)!.visibilityLabel),
        Icon(visibilityIcon),
      ],
    );
  }

  void _navigateToPublicProfile(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublicProfilePage(userId: user.id!),
      ),
    );
  }
}