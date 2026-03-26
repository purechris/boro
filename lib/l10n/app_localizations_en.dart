// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Boro';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get lendTo => 'Lend to...';

  @override
  String get retrieveItem => 'Retrieve';

  @override
  String get retrieveItemQuestion => 'Retrieve?';

  @override
  String get lendToTitle => 'Lend to...';

  @override
  String get lendToHint => 'Name';

  @override
  String get enterBorrowerName => 'Please enter a name';

  @override
  String get markAsReturned => 'Mark as returned';

  @override
  String get borrowedBadge => 'LENT';

  @override
  String borrowedBy(String name) {
    return 'Lent to $name';
  }

  @override
  String get error => 'Error';

  @override
  String get noItemsFound => 'No items found.';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get passwordChange => 'Change Password';

  @override
  String get category => 'Category';

  @override
  String get description => 'Description';

  @override
  String get location => 'Location';

  @override
  String get saving => 'Saving...';

  @override
  String get add => 'Add';

  @override
  String get loading => 'Loading...';

  @override
  String get articleDelete => 'Delete Article';

  @override
  String get noUserDataAvailable => 'No user data available.';

  @override
  String errorLoadingUser(String error) {
    return 'Error loading user';
  }

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get noDataFound => 'No data found';

  @override
  String get addFriends => 'Add Friends';

  @override
  String get addFriendsNow => 'Add Friends Now';

  @override
  String get removeFriendConfirm => 'Do you really want to remove this friend?';

  @override
  String get cancelFriendRequestConfirm =>
      'Do you really want to cancel this friend request?';

  @override
  String get rejectFriendRequestConfirm =>
      'Do you really want to reject this friend request?';

  @override
  String get selectCategory => 'Please select a category';

  @override
  String get descriptionMaxLength =>
      'The description must not exceed 500 characters';

  @override
  String get optional => 'optional';

  @override
  String get optionalLocation => 'Location (optional)';

  @override
  String get optionalLocationHint => '';

  @override
  String get optionalDescription => 'Description (optional)';

  @override
  String get profileIncomplete =>
      'Your profile is still incomplete. Add more information now!';

  @override
  String get aboutMe => 'About Me';

  @override
  String get cityLocation => 'City/Location (automatically determined)';

  @override
  String get cityLocationHint => '';

  @override
  String get cityNoNumbers => 'The location must not contain numbers';

  @override
  String get contact => 'Contact';

  @override
  String get contactHint => 'e.g. email address or phone number';

  @override
  String get profileSaving => 'Saving profile...';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackTitle => 'We appreciate your feedback!';

  @override
  String get feedbackMessage =>
      'Your opinion is important to us and helps us improve the app. Feel free to contact us if errors occur, translations can be improved, or if you have improvement suggestions/feature requests.';

  @override
  String get contactUs => 'Contact us:';

  @override
  String get copyEmailHint => 'Copy the email address and write us a message.';

  @override
  String get supportDeveloper => 'Support Developer';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get imprint => 'Imprint';

  @override
  String get account => 'Account';

  @override
  String get changePassword => 'Change Password';

  @override
  String get passwordReset => 'Reset Password';

  @override
  String linkCouldNotOpen(String url) {
    return 'Link could not be opened: $url';
  }

  @override
  String get navStart => 'Home';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navLend => 'Lend';

  @override
  String get navFriends => 'Friends';

  @override
  String get navMine => 'Mine';

  @override
  String get language => 'Language';

  @override
  String get languageGerman => 'German';

  @override
  String get languageEnglish => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get register => 'Register';

  @override
  String get signIn => 'Sign In';

  @override
  String get tryDemo => 'Try Demo';

  @override
  String get demoModeReadOnly => 'In demo mode, this action is disabled';

  @override
  String get slide1Text => 'Share your things with friends and family';

  @override
  String get slide2Text => 'Lend tools, camping equipment and more';

  @override
  String get slide3Text => 'Save money and protect the environment';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get passwordForgotten => 'Forgot password?';

  @override
  String get reset => 'Reset';

  @override
  String get noAccountYet => 'Don\'t have an account yet? ';

  @override
  String get accountAlreadyExists => 'Already have an account? ';

  @override
  String get displayName => 'Display Name';

  @override
  String get displayNameHint => 'This name will be shown to other users';

  @override
  String get displayNameRequired => 'Display name is required';

  @override
  String get displayNameMinLength =>
      'Display name must be at least 3 characters long';

  @override
  String get emailRequired => 'Email address is required';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get passwordMinLength =>
      'At least 8 characters, max 72. Must contain uppercase, lowercase and digits.';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLengthError =>
      'Password must be at least 8 characters long';

  @override
  String get passwordMaxLengthError => 'Password must not exceed 72 characters';

  @override
  String get passwordMissingLowercase =>
      'Password must contain at least one lowercase letter (a-z)';

  @override
  String get passwordMissingUppercase =>
      'Password must contain at least one uppercase letter (A-Z)';

  @override
  String get passwordMissingDigits =>
      'Password must contain at least one digit (0-9)';

  @override
  String get passwordTooShort => 'Too short';

  @override
  String get passwordTooLong => 'Too long (max 72 characters)';

  @override
  String get passwordNeedsLowercase => 'Needs lowercase letter';

  @override
  String get passwordNeedsUppercase => 'Needs uppercase letter';

  @override
  String get passwordNeedsDigits => 'Needs digit';

  @override
  String get emailAndPasswordRequired =>
      'Email address and password are required';

  @override
  String get lendNow => 'Lend Items Now';

  @override
  String get createFirstItems =>
      'Create your first 3 items you want to lend! Or add friends to expand your network!';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get tryOtherSearchTerms =>
      'Try different search terms or filter settings';

  @override
  String get searchResults => 'Search Results';

  @override
  String get quickFilter => 'Quick Filter';

  @override
  String get categories => 'Categories';

  @override
  String get search => 'Search...';

  @override
  String get searchItems => 'Search items';

  @override
  String get app => 'App';

  @override
  String get myProfile => 'My Profile';

  @override
  String get myAds => 'My Ads';

  @override
  String get editProfileTooltip => 'Edit Profile';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get articleDeletedSuccess => 'Article successfully deleted';

  @override
  String get addArticle => 'Add Article';

  @override
  String get editArticle => 'Edit Article';

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Please enter a title';

  @override
  String get titleMinLength => 'Title must be at least 5 characters long';

  @override
  String get titleMaxLength => 'Title must not exceed 50 characters';

  @override
  String get visibility => 'Visibility';

  @override
  String get friendsOfFriends => 'Friends of Friends';

  @override
  String get directFriends => 'Direct Friends';

  @override
  String get private => 'Private';

  @override
  String version(String version, String platform) {
    return 'Version $version ($platform)';
  }

  @override
  String get web => 'Web';

  @override
  String get android => 'Android';

  @override
  String get noFavoritesYet =>
      'No favorites yet. Browse items and add your favorites!';

  @override
  String get addFirstItems => 'Add your first 3 items you want to lend!';

  @override
  String get displayNameUnique => 'The name should be unique for your friends';

  @override
  String get nameRequired => 'Please enter a name';

  @override
  String get nameMinLength => 'Name must be at least 5 characters long';

  @override
  String get nameMaxLength => 'Name must not exceed 20 characters';

  @override
  String get profileUpdatedSuccess => 'Profile successfully updated';

  @override
  String get friends => 'Friends';

  @override
  String get yourFriends => 'Your Friends';

  @override
  String get addFriendsTab => 'Add Friends';

  @override
  String get friendCodeOrEmail => 'Friend Code or Email Address';

  @override
  String get yourFriendCode => 'Your Friend Code to Share';

  @override
  String get share => 'Share';

  @override
  String get copy => 'Copy';

  @override
  String get removeFriend => 'Remove Friend';

  @override
  String get removeFriendTitle => 'Remove Friend';

  @override
  String get remove => 'Remove';

  @override
  String get cancelRequest => 'Cancel Request';

  @override
  String get cancelRequestTitle => 'Cancel Request';

  @override
  String get receivedRequests => 'Received Friend Requests';

  @override
  String get sentRequests => 'Sent Friend Requests';

  @override
  String get rejectRequest => 'Reject Request';

  @override
  String get rejectRequestTitle => 'Reject Request';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get requestSent => 'Friend request has been sent!';

  @override
  String get requestAccepted => 'Friend request accepted';

  @override
  String get requestRejected => 'Friend request rejected';

  @override
  String get requestCancelled => 'Friend request cancelled';

  @override
  String get shareFriendCodeText =>
      'Share your friend code e.g. in a group with friends, colleagues or neighbors to expand your network!';

  @override
  String get friendCodeCopied => 'Friend code copied to clipboard';

  @override
  String get noAdsYet => 'No ads available';

  @override
  String get userHasNoAds => 'This user has not created any ads yet';

  @override
  String get currentAds => 'Current Ads';

  @override
  String get profile => 'Profile';

  @override
  String get friend => 'Friends';

  @override
  String get requestPending => 'Request Pending';

  @override
  String get addAsFriend => 'Add as Friend';

  @override
  String get filter => 'Filter';

  @override
  String get resetFilters => 'Reset';

  @override
  String get sorting => 'Sorting';

  @override
  String get newest => 'Newest First';

  @override
  String get oldest => 'Oldest First';

  @override
  String get alphabetical => 'Alphabetical';

  @override
  String get all => 'All';

  @override
  String get country => 'Country';

  @override
  String get country_DE => 'Germany';

  @override
  String get country_AT => 'Austria';

  @override
  String get country_CH => 'Switzerland';

  @override
  String get country_GB => 'United Kingdom';

  @override
  String get country_IE => 'Ireland';

  @override
  String get country_US => 'USA';

  @override
  String get country_CA => 'Canada';

  @override
  String get country_AU => 'Australia';

  @override
  String get country_NZ => 'New Zealand';

  @override
  String get country_NO => 'Norway';

  @override
  String get country_SE => 'Sweden';

  @override
  String get country_PL => 'Poland';

  @override
  String get country_CZ => 'Czech Republic';

  @override
  String get country_NL => 'Netherlands';

  @override
  String get country_BE => 'Belgium';

  @override
  String get country_LU => 'Luxembourg';

  @override
  String get country_FR => 'France';

  @override
  String get country_IT => 'Italy';

  @override
  String get country_ES => 'Spain';

  @override
  String get selectCountry => 'Select country';

  @override
  String get differentLocation => 'Alternative location';

  @override
  String get differentLocationHint =>
      'Enable if the item is in a different location than your profile-location.';

  @override
  String get postalCode => 'Postal code';

  @override
  String get postalCodeOptional => 'Postal code (optional)';

  @override
  String get postalCodeFilterLabel => 'Postal code';

  @override
  String get postalCodeFilterHint => 'e.g. 10115';

  @override
  String get maxDistanceLabel => 'Maximum distance';

  @override
  String get distanceFilterTooltip => 'Starting from your profile location';

  @override
  String get distanceUnlimited => 'Unlimited';

  @override
  String get distanceFilterLabel => 'Distance';

  @override
  String distanceFilterValue(int distance) {
    return '$distance km';
  }

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordDescription =>
      'Enter your email address to receive a 6-digit code to reset your password.';

  @override
  String get emailRequiredForReset => 'Please enter your email address';

  @override
  String get emailInvalidForReset => 'Please enter a valid email address';

  @override
  String get sendCode => 'Send Code';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get currentPasswordRequired => 'Please enter your current password';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordRequired => 'Please enter a new password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordRequired => 'Please confirm your new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get newPasswordSameAsOld =>
      'New password must be different from the current password';

  @override
  String get passwordChangedSuccess => 'Password successfully changed';

  @override
  String get currentPasswordIncorrect => 'Current password is incorrect';

  @override
  String get userNotFound => 'User not found';

  @override
  String get profileLoadError => 'Error loading profile';

  @override
  String get userCouldNotBeLoaded => 'The user could not be loaded';

  @override
  String get offerType => 'Offer Type';

  @override
  String get allOfferTypes => 'All Offer Types';

  @override
  String get selectSorting => 'Please select a sorting';

  @override
  String get selectType => 'Please select a type';

  @override
  String get applyFilter => 'Apply Filter';

  @override
  String get enterCode => 'Enter Code';

  @override
  String codeSentToEmail(String email) {
    return 'A 6-digit code has been sent to $email. Please check your inbox.';
  }

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get enterFullCode => 'Please enter the complete 6-digit code';

  @override
  String get codeVerifiedMessage =>
      'Please enter a new password. The code has been successfully verified.';

  @override
  String get supportDeveloperTitle => 'Support the Developer!';

  @override
  String get supportDeveloperText =>
      'If you like the app, you can support me with a donation :) Your support helps me cover server costs and continue developing the app. Click the button to make a donation via PayPal.';

  @override
  String get paypalDonateLink => 'PayPal Donation Link';

  @override
  String get thanksForSupport => 'Thanks for your support!';

  @override
  String get offerTypeOffer => 'Lend';

  @override
  String get offerTypeOfferCard => 'To Lend';

  @override
  String get offerTypeFree => 'Free';

  @override
  String get offerTypeFreeCard => 'Free';

  @override
  String get offerTypeSearch => 'Search';

  @override
  String get offerTypeSearchCard => 'Search';

  @override
  String get offerTypeSell => 'Sell';

  @override
  String get offerTypeSellCard => 'For Sale';

  @override
  String get newBadge => 'NEW';

  @override
  String get badgeTopLenderTitle => 'Top Lender';

  @override
  String get badgeTopLenderDescription => 'At least 3 items listed';

  @override
  String get badgeEarlyUserTitle => 'Supporter';

  @override
  String get badgeEarlyUserDescription => 'From the beginning';

  @override
  String get badgeTopNetworkedTitle => 'Well Connected';

  @override
  String get badgeTopNetworkedDescription => '5 or more direct friends';

  @override
  String get details => 'Details';

  @override
  String get categoryLabel => 'Category:';

  @override
  String get offerTypeLabel => 'Offer Type:';

  @override
  String get offerTypeFormLabel => 'Offer Type';

  @override
  String get articleLocationLabel => 'Article Location:';

  @override
  String get postedOnLabel => 'Posted on:';

  @override
  String get noDescriptionAvailable => '- No description available -';

  @override
  String get memberSince => 'Member since';

  @override
  String get week => 'Week';

  @override
  String get weeks => 'Weeks';

  @override
  String get month => 'Month';

  @override
  String get months => 'Months';

  @override
  String get year => 'Year';

  @override
  String get years => 'Years';

  @override
  String get people => 'People';

  @override
  String get direct => 'direct';

  @override
  String get indirect => 'indirect';

  @override
  String get mutualFriends => 'Mutual Friends: ';

  @override
  String get categoryCamping => 'Camping';

  @override
  String get categoryFahrrad => 'Bicycle';

  @override
  String get categoryWerkzeug => 'Tools';

  @override
  String get categoryReisen => 'Travel';

  @override
  String get categoryHaushalt => 'Household';

  @override
  String get categoryMusik => 'Music';

  @override
  String get categoryBuecher => 'Books';

  @override
  String get categorySport => 'Sports';

  @override
  String get categoryKueche => 'Kitchen';

  @override
  String get categorySpiele => 'Games';

  @override
  String get categoryFotografie => 'Photography';

  @override
  String get categoryUmzug => 'Moving';

  @override
  String get categoryTechnik => 'Tech';

  @override
  String get categorySonstiges => 'Other';

  @override
  String get articleSavedSuccessTitle => 'Great!';

  @override
  String get articleSavedSuccessMessage =>
      'Your entry has been saved successfully! :)';

  @override
  String get continueButton => 'Continue';

  @override
  String get visibilityLabel => 'Visibility:';

  @override
  String get deleteArticleConfirm =>
      'Do you really want to delete this article?';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get emailNotConfirmed =>
      'Please confirm your email address to sign in.';

  @override
  String get invalidCredentials => 'Invalid email address or password';

  @override
  String get invalidImageType =>
      'Moving images (videos, GIFs) are not supported';

  @override
  String get fileTooLarge => 'The image is too large. Maximum size: 15MB';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get retry => 'Try again';

  @override
  String get invalidOrExpiredCode => 'Invalid or expired code';

  @override
  String get tooManyRegistrationAttempts =>
      'Too many registration attempts. Please try again later.';

  @override
  String get passwordDoesNotMeetRequirements =>
      'The password does not meet the requirements.';

  @override
  String get cannotSendRequestToSelf =>
      'You cannot send a friend request to yourself';

  @override
  String get userNotFoundByEmail => 'No user found with this email address';

  @override
  String get userNotFoundByFriendCode => 'No user found with this friend code';

  @override
  String get friendRequestAlreadyExists => 'A friend request already exists';

  @override
  String confirmationEmailSent(String email) {
    return 'A confirmation email has been sent to $email. Please check your inbox.';
  }

  @override
  String get articleRemovedFromFavorites => 'Article removed from favorites';

  @override
  String get articleAddedToFavorites => 'Article added to favorites';

  @override
  String get errorLoadingArticle => 'Error loading article';

  @override
  String get articleCouldNotBeLoaded => 'The article could not be loaded';

  @override
  String get articleNotFound => 'Article not found';

  @override
  String get noImageAvailable => 'No image available';

  @override
  String get languageSettingsTitle => 'Language';

  @override
  String get languageSettingsDescription =>
      'The language is chosen based on the system settings.';

  @override
  String get languageSettingsAvailableLanguages => 'Available languages:';

  @override
  String get languageSettingsEnglish => 'English';

  @override
  String get languageSettingsGerman => 'German';

  @override
  String get navCommunity => 'Community';

  @override
  String get community => 'Community';

  @override
  String get groups => 'Groups';

  @override
  String get addFriendOrGroup => 'Add Friend or Group';

  @override
  String get friendCodeOrGroupCode => 'Friend Code or Group Code';

  @override
  String get enterFriendOrGroupCode => 'Enter friend code or group code';

  @override
  String get pendingRequests => 'Pending Requests';

  @override
  String get noFriendsYet => 'No friends yet';

  @override
  String get noGroupsYet => 'No groups yet';

  @override
  String get createGroup => 'Create Group';

  @override
  String get groupName => 'Group Name';

  @override
  String get groupDescription => 'Group Description';

  @override
  String get groupCode => 'Group Code';

  @override
  String get groupCodeCopied => 'Group code copied';

  @override
  String get renewGroupCode => 'Renew Group Code';

  @override
  String get groupCodeRenewed => 'Group code renewed';

  @override
  String get members => 'Members';

  @override
  String get noMembers => 'No members';

  @override
  String get groupItems => 'Group Items';

  @override
  String get admin => 'Admin';

  @override
  String get makeAdmin => 'Make Admin';

  @override
  String get removeMember => 'Remove Member';

  @override
  String get removeMemberTitle => 'Remove Member';

  @override
  String get removeMemberConfirm => 'Do you really want to remove this member?';

  @override
  String get memberRemoved => 'Member removed';

  @override
  String get adminChanged => 'Admin changed';

  @override
  String get deleteGroup => 'Delete Group';

  @override
  String get deleteGroupTitle => 'Delete Group';

  @override
  String get deleteGroupConfirm => 'Do you really want to delete this group?';

  @override
  String get leave => 'Leave';

  @override
  String get leaveGroup => 'Leave group';

  @override
  String get leaveGroupTitle => 'Leave group';

  @override
  String get leaveGroupConfirm => 'Do you really want to leave this group?';

  @override
  String get leaveGroupSuccess => 'You left the group';

  @override
  String get groupDeleted => 'Group deleted';

  @override
  String get groupCreated => 'Group created';

  @override
  String get groupUpdatedSuccess => 'Group successfully updated';

  @override
  String get groupNotFound => 'Group not found';

  @override
  String get editGroup => 'Edit Group';

  @override
  String get groupNameRequired => 'Please enter a group name';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get addFriend => 'Add Friend';

  @override
  String get joinGroup => 'Join Group';

  @override
  String get create => 'Create';

  @override
  String get demoMode => 'DEMO-MODE';

  @override
  String get demoBannerClickToExit => 'Demo Mode (Tap to Exit)';

  @override
  String get selectAtLeastOneGroup => 'Please select at least one group.';

  @override
  String get groupNameTooLong => 'Group name is too long (max. 20 characters)';

  @override
  String get renewGroupCodeConfirm =>
      'Do you really want to renew the group code? The old code will become invalid immediately and new members will not be able to join with it.';

  @override
  String get enterGroupCode => 'Please enter a group code';

  @override
  String get joinGroupSuccess => 'You have joined the group';
}
