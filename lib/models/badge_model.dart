import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Enum for different badge types.
enum BadgeType {
  topLender,
  earlyUser,
  topNetworked,
}

/// Model representing a user achievement badge.
class BadgeModel {
  final BadgeType type;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final int priority; // Lower number = higher priority (1 is highest priority)

  const BadgeModel({
    required this.type,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.priority,
  });

  /// Get the localized badge title.
  String getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case BadgeType.topLender:
        return l10n.badgeTopLenderTitle;
      case BadgeType.earlyUser:
        return l10n.badgeEarlyUserTitle;
      case BadgeType.topNetworked:
        return l10n.badgeTopNetworkedTitle;
    }
  }

  /// Get the localized badge description.
  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case BadgeType.topLender:
        return l10n.badgeTopLenderDescription;
      case BadgeType.earlyUser:
        return l10n.badgeEarlyUserDescription;
      case BadgeType.topNetworked:
        return l10n.badgeTopNetworkedDescription;
    }
  }

  /// Factory-Methode um Badge basierend auf Typ zu erstellen
  factory BadgeModel.fromType(BadgeType type) {
    switch (type) {
      case BadgeType.topLender:
        return const BadgeModel(
          type: BadgeType.topLender,
          icon: Icons.local_offer,
          color: Colors.green,
          backgroundColor: Color(0xFFE8F5E9), // Green shade 50
          priority: 2,
        );
      case BadgeType.earlyUser:
        return const BadgeModel(
          type: BadgeType.earlyUser,
          icon: Icons.rocket_launch,
          color: Colors.purple,
          backgroundColor: Color(0xFFF3E5F5), // Purple shade 50
          priority: 1,
        );
      case BadgeType.topNetworked:
        return const BadgeModel(
          type: BadgeType.topNetworked,
          icon: Icons.people,
          color: Colors.blue,
          backgroundColor: Color(0xFFE3F2FD), // Blue shade 50
          priority: 3,
        );
    }
  }
}

/// Utility class for badge logic.
class BadgeUtils {
  /// Determine which badges a user should have based on their data.
  /// Returns badges sorted by priority.
  static List<BadgeModel> getBadgesForUser({
    required DateTime created,
    int? lendableCount,
    int? friendCount,
  }) {
    final badges = <BadgeModel>[];

    // Top lender (at least 3 items)
    if (lendableCount != null && lendableCount >= 3) {
      badges.add(BadgeModel.fromType(BadgeType.topLender));
    }

    // Early user (registered by 2025 or earlier)
    final year2025 = DateTime(2025, 12, 31);
    if (created.isBefore(year2025) || created.isAtSameMomentAs(year2025)) {
      badges.add(BadgeModel.fromType(BadgeType.earlyUser));
    }

    // Well networked (at least 5 direct friends)
    if (friendCount != null && friendCount >= 5) {
      badges.add(BadgeModel.fromType(BadgeType.topNetworked));
    }

    // Sort by priority (lower number = higher priority)
    badges.sort((a, b) => a.priority.compareTo(b.priority));

    // Return at most 3 badges
    return badges.take(3).toList();
  }
}

