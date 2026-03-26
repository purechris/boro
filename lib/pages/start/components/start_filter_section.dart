import 'package:flutter/material.dart';
import 'package:verleihapp/config/constants.dart';
import 'package:verleihapp/models/filter_state.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Filter chips and bottom sheets for the start page.
/// Extracted from start.dart to reduce file size.
class StartFilterSection extends StatelessWidget {
  final FilterState currentFilters;
  final VoidCallback onResetFilters;
  final Function(FilterState) onFiltersChanged;

  const StartFilterSection({
    super.key,
    required this.currentFilters,
    required this.onResetFilters,
    required this.onFiltersChanged,
  });

  static const double _unlimitedDistance = 205.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String sorting = currentFilters.sorting;
    final String type = currentFilters.type;
    final int? maxDistanceKm = currentFilters.maxDistanceKm;
    
    int activeFilterCount = 0;
    if (currentFilters.category != AppConstants.filterAll) activeFilterCount++;
    if (currentFilters.type != AppConstants.filterAll) activeFilterCount++;
    if (currentFilters.maxDistanceKm != null) activeFilterCount++;
    
    final bool hasActiveFilters = activeFilterCount > 0 || sorting != SortingMode.newest.value;

    String sortingLabel = '';
    if (sorting == SortingMode.newest.value) {
      sortingLabel = l10n.newest;
    } else if (sorting == SortingMode.oldest.value) {
      sortingLabel = l10n.oldest;
    } else if (sorting == SortingMode.alphabetical.value) {
      sortingLabel = l10n.alphabetical;
    }

    final String distanceLabel = maxDistanceKm == null
        ? l10n.distanceUnlimited
        : l10n.distanceFilterValue(maxDistanceKm);

    final types = LendableModel.getLendableTypes(context);
    String typeLabel = l10n.allOfferTypes;
    if (type != AppConstants.filterAll) {
      final selectedType = types.firstWhere((t) => t['value'] == type, orElse: () => {});
      if (selectedType.isNotEmpty) {
        typeLabel = 'Nur: ${selectedType['displayCard']!}';
      }
    }

    final chips = [
      _FilterChipData(
        isActive: type != AppConstants.filterAll,
        label: typeLabel,
        onTap: () => _showTypeBottomSheet(context),
        icon: Icons.sell_outlined,
      ),
      _FilterChipData(
        isActive: sorting != SortingMode.newest.value,
        label: sortingLabel,
        onTap: () => _showSortingBottomSheet(context),
        icon: Icons.sort,
      ),
      _FilterChipData(
        isActive: maxDistanceKm != null,
        label: distanceLabel,
        onTap: () => _showDistanceBottomSheet(context),
        icon: Icons.location_on_outlined,
      ),
    ];

    chips.sort((a, b) {
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;
      return 0;
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (hasActiveFilters)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                onPressed: onResetFilters,
                label: const Icon(Icons.filter_alt_off_outlined, size: 20, color: Colors.grey),
                backgroundColor: Colors.grey.withValues(alpha: 0.1),
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                side: BorderSide.none,
              ),
            ),
          ...chips.expand((chip) => [
            _buildActionChip(
              context,
              label: chip.label,
              onTap: chip.onTap,
              isActive: chip.isActive,
              icon: chip.icon,
            ),
            const SizedBox(width: 8),
          ]).toList()..removeLast(),
        ],
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    required IconData icon,
  }) {
    return ActionChip(
      onPressed: onTap,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive ? Colors.black : Colors.black54,
          ),
          const SizedBox(width: 6),
          Text(label),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 18, color: Colors.black54),
        ],
      ),
      backgroundColor: isActive ? Colors.green.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
      elevation: 0,
      pressElevation: 0,
      side: isActive 
          ? const BorderSide(color: Colors.green, width: 1)
          : BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelStyle: TextStyle(
        color: Colors.black,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      padding: EdgeInsets.zero,
    );
  }

  void _showSortingBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child:               RadioGroup<String>(
                groupValue: currentFilters.sorting,
                onChanged: (val) => _updateSorting(context, val!),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        l10n.sorting,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(l10n.newest),
                      leading: Radio<String>(
                        value: SortingMode.newest.value,
                      ),
                      onTap: () => _updateSorting(context, SortingMode.newest.value),
                    ),
                    ListTile(
                      title: Text(l10n.oldest),
                      leading: Radio<String>(
                        value: SortingMode.oldest.value,
                      ),
                      onTap: () => _updateSorting(context, SortingMode.oldest.value),
                    ),
                    ListTile(
                      title: Text(l10n.alphabetical),
                      leading: Radio<String>(
                        value: SortingMode.alphabetical.value,
                      ),
                      onTap: () => _updateSorting(context, SortingMode.alphabetical.value),
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }

  void _updateSorting(BuildContext context, String val) {
    onFiltersChanged(currentFilters.copyWith(sorting: val));
    Navigator.pop(context);
  }

  void _showTypeBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final types = LendableModel.getLendableTypes(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child:               RadioGroup<String>(
                groupValue: currentFilters.type,
                onChanged: (val) => _updateType(context, val!),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        l10n.offerType,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(l10n.allOfferTypes),
                      leading: Radio<String>(
                        value: AppConstants.filterAll,
                      ),
                      onTap: () => _updateType(context, AppConstants.filterAll),
                    ),
                    ...types.map((t) => ListTile(
                      title: Text(t['displayCard']!),
                      leading: Radio<String>(
                        value: t['value'] ?? AppConstants.filterAll,
                      ),
                      onTap: () => _updateType(context, t['value'] ?? AppConstants.filterAll),
                    )),
                  ],
                ),
              ),
        );
      },
    );
  }

  void _updateType(BuildContext context, String val) {
    onFiltersChanged(currentFilters.copyWith(type: val));
    Navigator.pop(context);
  }

  void _showDistanceBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    double tempDistance = (currentFilters.maxDistanceKm ?? _unlimitedDistance).toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bool isUnlimited = tempDistance >= _unlimitedDistance;
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.maxDistanceLabel,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isUnlimited ? l10n.distanceUnlimited : l10n.distanceFilterValue(tempDistance.round()),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: tempDistance.clamp(0, _unlimitedDistance),
                    min: 0,
                    max: _unlimitedDistance,
                    onChanged: (val) {
                      setModalState(() {
                        if (val >= 202.5) {
                          tempDistance = _unlimitedDistance;
                        } else {
                          tempDistance = (val / 5).round() * 5.0;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onFiltersChanged(currentFilters.copyWith(
                          maxDistanceKm: tempDistance >= _unlimitedDistance ? null : tempDistance.toInt(),
                          resetMaxDistanceKm: tempDistance >= _unlimitedDistance,
                        ));
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(l10n.applyFilter),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterChipData {
  final bool isActive;
  final String label;
  final VoidCallback onTap;
  final IconData icon;

  _FilterChipData({
    required this.isActive,
    required this.label,
    required this.onTap,
    required this.icon,
  });
}
