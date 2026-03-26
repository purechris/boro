import 'package:verleihapp/config/constants.dart';

/// State representing the filters applied on the start page.
class FilterState {
  final String category;
  final String type;
  final String sorting;
  final int? maxDistanceKm;

  const FilterState({
    required this.category,
    required this.type,
    required this.sorting,
    this.maxDistanceKm,
  });

  /// Initial filter state with default values.
  factory FilterState.initial() {
    return FilterState(
      category: AppConstants.filterAll,
      type: AppConstants.filterAll,
      sorting: SortingMode.newest.value,
      maxDistanceKm: null,
    );
  }

  FilterState copyWith({
    String? category,
    String? type,
    String? sorting,
    int? maxDistanceKm,
    bool resetMaxDistanceKm = false,
  }) {
    return FilterState(
      category: category ?? this.category,
      type: type ?? this.type,
      sorting: sorting ?? this.sorting,
      maxDistanceKm: resetMaxDistanceKm ? null : (maxDistanceKm ?? this.maxDistanceKm),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterState &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          type == other.type &&
          sorting == other.sorting &&
          maxDistanceKm == other.maxDistanceKm;

  @override
  int get hashCode =>
      category.hashCode ^ type.hashCode ^ sorting.hashCode ^ maxDistanceKm.hashCode;
}
