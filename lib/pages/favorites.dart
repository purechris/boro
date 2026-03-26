import 'package:flutter/material.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/services/favorite_service.dart';
import 'package:verleihapp/components/lendable_list.dart';
import 'package:verleihapp/pages/home.dart';
import 'package:verleihapp/utils/navigation_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// A page that displays the user's favorites.
/// Enables users to view and manage their favorited items.
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoriteService _favoriteService = FavoriteService();
  late Future<List<Map<LendableModel, UserModel>>> _favoriteLendables;

  @override
  void initState() {
    super.initState();
    _loadFavorites();

  }

  /// Load the user's favorited items from the database.
  Future<void> _loadFavorites() async {
    setState(() {
      _favoriteLendables = _favoriteService.getFavorites();
    });
  }

  /// Called when the user returns from the detail page.
  void _onReturnFromDetail() {
    _loadFavorites();
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
              Icons.favorite_border,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noFavoritesYet,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  NavigationUtils.navigateToAndClearStack(
                    context,
                    const HomePage(initialIndex: 0),
                  );
                },
                icon: const Icon(Icons.search),
                label: Text(AppLocalizations.of(context)!.searchItems),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadFavorites,
          child: FutureBuilder<List<Map<LendableModel, UserModel>>>(
          future: _favoriteLendables,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 
                       kToolbarHeight - 
                       MediaQuery.of(context).padding.top,
                child: _buildEmptyState(),
              );
            }

            return ListView(
              children: [
                const SizedBox(height: 15),
                LendableList(
                  lendablesFuture: _favoriteLendables,
                  emptyState: _buildEmptyState(),
                  onReturnFromDetail: _onReturnFromDetail,
                ),
              ],
            );
          },
        ),
      ),
    ),
    );
  }

  /// Build the app bar for the favorites page.
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.navFavorites),
      centerTitle: true,
    );
  }
}