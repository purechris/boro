/// App-wide constants for table names, RPC names, and common keys.
class AppConstants {
  // Table Names
  static const String tableLendables = 'lendables';
  static const String tableProfiles = 'profiles';
  static const String tableCategories = 'categories';
  static const String tableGroups = 'groups';
  static const String tableFriends = 'friends';
  static const String tableLendableGroups = 'lendable_groups';
  static const String tableBadges = 'badges';
  static const String tableUserBadges = 'user_badges';

  // RPC Names
  static const String rpcGetNearbyLendables = 'get_nearby_lendables';
  static const String rpcGetLendablesForStartPage = 'get_lendables_with_user_data';
  static const String rpcGetLendablesFromSpecificUser = 'get_lendables_from_specific_user';
  static const String rpcGetLendablesForPublicProfile = 'get_lendables_for_public_profile';
  static const String rpcGetLendablesForGroup = 'get_lendables_for_group';
  static const String rpcSearchLendables = 'search_lendables';

  // Common Keys
  static const String keyId = 'id';
  static const String keyUserId = 'user_id';
  static const String keyCreated = 'created';
  
  // Filter Constants
  static const String filterAll = 'all';

  // Error Codes
  static const String errorGeneric = 'ERROR_GENERIC';
  static const String errorAuthTooManyAttempts = 'AUTH_TOO_MANY_ATTEMPTS';
  static const String errorAuthPasswordRequirements = 'AUTH_PASSWORD_REQUIREMENTS';
  static const String errorAuthSignupFailed = 'AUTH_SIGNUP_FAILED';
  static const String errorFriendAlreadyExists = 'FRIEND_ALREADY_EXISTS';
  static const String errorFriendRequestExists = 'FRIEND_REQUEST_EXISTS';
  static const String errorFriendRequestSentToSelf = 'FRIEND_REQUEST_SENT_TO_SELF';
  static const String errorUserNotFound = 'USER_NOT_FOUND';
}

/// Enum for Lendable item types.
enum LendableType {
  offer('offer'),
  free('free'),
  sell('sell'),
  search('search');

  final String value;
  const LendableType(this.value);

  static LendableType fromString(String? value) {
    if (value == null) return LendableType.offer;
    return LendableType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LendableType.offer,
    );
  }
}

/// Enum for item visibility.
enum VisibilityMode {
  all('all'),
  friends('friends'),
  specific('specific'),
  indirectContacts('indirect-contacts');

  final String value;
  const VisibilityMode(this.value);

  static VisibilityMode fromString(String? value) {
    if (value == null) return VisibilityMode.all;
    return VisibilityMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VisibilityMode.all,
    );
  }
}

/// Enum for sorting modes on the start page.
enum SortingMode {
  newest('newest'),
  oldest('oldest'),
  alphabetical('alphabetical');

  final String value;
  const SortingMode(this.value);

  static SortingMode fromString(String? value) {
    if (value == null) return SortingMode.newest;
    return SortingMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SortingMode.newest,
    );
  }
}
