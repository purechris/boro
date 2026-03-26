import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Search bar for the start page.
/// Extracted from start.dart to reduce file size.
class StartSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchTerm;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const StartSearchBar({
    super.key,
    required this.searchController,
    required this.searchTerm,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: AppLocalizations.of(context)!.search,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 179, 179, 179),
            fontSize: 16,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.search),
          ),
          suffixIcon: _buildClearButton(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }

  Widget _buildClearButton() {
    return searchTerm.isEmpty
        ? const SizedBox.shrink()
        : IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onClearSearch,
          );
  }
}
