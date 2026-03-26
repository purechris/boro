import 'package:flutter/material.dart';
import 'package:verleihapp/pages/favorites.dart';
import 'package:verleihapp/pages/friends/friendlist.dart';
import 'package:verleihapp/pages/groups/groups_page.dart';
import 'package:verleihapp/pages/private_profile.dart';
import 'package:verleihapp/pages/start/start.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/components/demo_mode_banner.dart';

/// Main page of the app, serving as a container for all other pages.
/// Contains bottom navigation for switching between main pages.
class HomePage extends StatefulWidget {
  final int initialIndex;
  
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // UI constants
  static const double _iconSize = 24.0;
  static const double _labelFontSize = 12.0;

  // Services
  final UserService _userService = UserService();

  // State variables
  int _selectedIndex = 0;

  // Page widgets
  static final List<Widget> _pages = <Widget>[
    const StartPage(),
    const FavoritesPage(),
    const FriendlistPage(),
    const GroupsPage(),
    const PrivateProfilePage(),
  ];

  // Navigation items - created in build() because localization is required
  List<BottomNavigationBarItem> _getNavigationItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined, size: _iconSize),
        activeIcon: const Icon(Icons.home, size: _iconSize),
        label: l10n.navStart,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.favorite_border, size: _iconSize),
        activeIcon: const Icon(Icons.favorite, size: _iconSize),
        label: l10n.navFavorites,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.group_outlined, size: _iconSize),
        activeIcon: const Icon(Icons.group, size: _iconSize),
        label: l10n.friends,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.groups_outlined, size: _iconSize),
        activeIcon: const Icon(Icons.groups, size: _iconSize),
        label: l10n.groups,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline, size: _iconSize),
        activeIcon: const Icon(Icons.person, size: _iconSize),
        label: l10n.navMine,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_userService.isDemoUser())
            const DemoModeBanner(),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: _getNavigationItems(context),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedFontSize: _labelFontSize,
            unselectedFontSize: _labelFontSize,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }
}