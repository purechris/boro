import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verleihapp/config/constants.dart';
import 'package:verleihapp/models/category_model.dart';
import 'package:verleihapp/models/filter_state.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Categories scrollable section for the start page.
/// Extracted from start.dart to reduce file size.
class StartCategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final FilterState currentFilters;
  final ScrollController scrollController;
  final Function(String) onCategorySelected;

  const StartCategoriesSection({
    super.key,
    required this.categories,
    required this.currentFilters,
    required this.scrollController,
    required this.onCategorySelected,
  });

  List<CategoryModel> _getSortedCategories() {
    final selectedCategory = currentFilters.category;
    if (selectedCategory == AppConstants.filterAll) return categories;
    
    final List<CategoryModel> sorted = List.from(categories);
    final selectedIndex = sorted.indexWhere((c) => c.name == selectedCategory);
    if (selectedIndex != -1) {
      final category = sorted.removeAt(selectedIndex);
      sorted.insert(0, category);
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final sortedCategories = _getSortedCategories();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            AppLocalizations.of(context)!.categories,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            ),
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: kIsWeb,
              child: ListView.separated(
                controller: scrollController,
                itemCount: sortedCategories.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context, index) => _buildCategoryItem(context, index, sortedCategories),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index, List<CategoryModel> categories) {
    final category = categories[index];
    final isSelected = currentFilters.category == category.name;
    
    return GestureDetector(
      onTap: () {
        onCategorySelected(isSelected ? AppConstants.filterAll : category.name);
        
        // Scroll left when a filter is selected
        if (!isSelected) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.green, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(category.iconPath),
              ),
            ),
            Text(
              category.getLocalizedName(context),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
