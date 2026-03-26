import 'package:verleihapp/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:verleihapp/models/category_model.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/models/filter_state.dart';
import 'package:verleihapp/pages/post_lendable/post_lendable.dart';
import 'package:verleihapp/services/lendable_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/utils/string_utils.dart';
import 'package:verleihapp/utils/location_utils.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/components/lendable_list.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/pages/start/components/start_search_bar.dart';
import 'package:verleihapp/pages/start/components/start_filter_section.dart';
import 'package:verleihapp/pages/start/components/start_categories_section.dart';
import 'package:verleihapp/pages/start/components/start_empty_states.dart';

/// The start page of the app, displaying all available items.
/// Contains search functionality, category filters, and sorting options.
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final LendableService _lendableService = LendableService();
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _categoriesScrollController = ScrollController();

  // State variables
  List<CategoryModel> _categories = [];
  String _searchTerm = '';
  List<Map<LendableModel, UserModel>> _allLendables = [];
  List<Map<LendableModel, UserModel>> _filteredLendables = [];
  bool _isLoading = true;
  UserModel? _currentUser;
  FilterState _currentFilters = FilterState.initial();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoriesScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool resetFilters = false}) async {
    try {
      final results = await Future.wait([
        _lendableService.getLendablesForStartPage(),
        _userService.getCurrentUser(),
      ]);

      final lendables = results[0] as List<Map<LendableModel, UserModel>>;
      final currentUser = results[1] as UserModel?;

      if (mounted) {
        setState(() {
          _allLendables = lendables;
          _currentUser = currentUser;
          _filteredLendables = List.from(_allLendables);
          _categories = CategoryModel.getCategories();
          _isLoading = false;
          // Reset filters if needed (e.g., on refresh)
          if (resetFilters) {
            _currentFilters = FilterState.initial();
            _searchTerm = '';
            _searchController.clear();
          }
        });
        // Apply filters after loading
        _applyFilters(searchTerm: _searchTerm);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Show error to user
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorLoadingData);
        debugPrint('Error loading start page data: $e');
      }
    }
  }

  void _clearSearch() {
    setState(() {
      _searchTerm = '';
      _searchController.clear();
      _applyFilters(searchTerm: _searchTerm);
    });
    FocusScope.of(context).unfocus();
  }

  void _applyFilters({String searchTerm = ''}) {
    final String category = _currentFilters.category;
    final String type = _currentFilters.type;
    final String sorting = _currentFilters.sorting;
    final int? maxDistanceKm = _currentFilters.maxDistanceKm;

    setState(() {
      _filteredLendables = _allLendables.where((entry) {
        final lendable = entry.keys.first;
        final owner = entry.values.first;
        
        final lendableCategory = lendable.category;
        final lendableType = lendable.type;
        final title = lendable.title.toLowerCase();

        // 1. Kategoriefilter
        if (category != AppConstants.filterAll && lendableCategory != category) return false;
        
        // 2. Typfilter
        if (type != AppConstants.filterAll && lendableType != type) return false;
        
        // 3. Suchbegriff
        if (searchTerm.isNotEmpty) {
          final matchesSearch = title.contains(searchTerm.toLowerCase()) ||
              StringUtils.levenshteinDistance(title, searchTerm.toLowerCase()) <= 3;
          if (!matchesSearch) return false;
        }

        // 4. Distanzfilter
        if (maxDistanceKm != null && _currentUser != null) {
          // Eigene Artikel immer anzeigen
          if (lendable.userId == _currentUser!.id) return true;

          // Standort ermitteln: Artikel-Standort bevorzugt, sonst Besitzer-Standort
          final double? targetLat = lendable.latitude ?? owner.latitude;
          final double? targetLon = lendable.longitude ?? owner.longitude;
          final double? userLat = _currentUser!.latitude;
          final double? userLon = _currentUser!.longitude;

          if (targetLat != null && targetLon != null && userLat != null && userLon != null) {
            final distance = LocationUtils.calculateDistance(userLat, userLon, targetLat, targetLon);
            if (distance > maxDistanceKm) return false;
          } else {
            // Wenn kein Standort vorhanden ist und ein Distanzfilter aktiv ist, Artikel ausblenden
            return false;
          }
        }

        return true;
      }).toList();

      if (sorting == SortingMode.newest.value) {
        _filteredLendables.sort((a, b) => b.keys.first.created.compareTo(a.keys.first.created));
      } else if (sorting == SortingMode.oldest.value) {
        _filteredLendables.sort((a, b) => a.keys.first.created.compareTo(b.keys.first.created));
      } else if (sorting == SortingMode.alphabetical.value) {
        _filteredLendables.sort((a, b) => a.keys.first.title.toLowerCase().compareTo(b.keys.first.title.toLowerCase()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: RefreshIndicator(
            onRefresh: () => _loadData(resetFilters: true),
            child: _isLoading
                ? Column(
                    children: [
                      _buildTopSection(),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  )
                : _allLendables.isEmpty
                    ? Column(
                        children: [
                          _buildTopSection(),
                          const Expanded(
                            child: NoItemsEmptyState(),
                          ),
                        ],
                      )
                    : ListView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        children: [
                          _buildTopSection(),
                          const SizedBox(height: 20),
                          if (_filteredLendables.isEmpty)
                            const NoResultsEmptyState()
                          else
                            LendableList(
                              lendables: _filteredLendables,
                              title: AppLocalizations.of(context)!.searchResults,
                            ),
                        ],
                      ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'start_page_fab',
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

  Widget _buildTopSection() {
    return Column(
      children: [
        StartSearchBar(
          searchController: _searchController,
          searchTerm: _searchTerm,
          onSearchChanged: (value) {
            setState(() => _searchTerm = value);
            _applyFilters(searchTerm: value);
          },
          onClearSearch: _clearSearch,
        ),
        const SizedBox(height: 10),
        StartFilterSection(
          currentFilters: _currentFilters,
          onResetFilters: () => _loadData(resetFilters: true),
          onFiltersChanged: (newFilters) {
            setState(() => _currentFilters = newFilters);
            _applyFilters(searchTerm: _searchTerm);
          },
        ),
        const SizedBox(height: 20),
        StartCategoriesSection(
          categories: _categories,
          currentFilters: _currentFilters,
          scrollController: _categoriesScrollController,
          onCategorySelected: (categoryName) {
            setState(() {
              _currentFilters = _currentFilters.copyWith(category: categoryName);
            });
            _applyFilters(searchTerm: _searchTerm);
          },
        ),
      ],
    );
  }
}
