# BORO Architecture

> **Note:** This is a living document and may not always reflect the latest changes in the codebase.
> **Last Updated:** March 26, 2026

## Overview

BORO is a Flutter application designed to enable users to lend, donate, and find items within their community. The application follows a clean, service-oriented architecture with a focus on separation of concerns and maintainability.

**Key Backend:** Supabase (PostgreSQL database, authentication, and file storage)

## Architecture Principles

### 1. Layered Architecture

The application is organized into distinct layers:

```
UI Layer (Pages & Components)
    ↓
Service Layer (Business Logic)
    ↓
Data Layer (Models & Supabase)
```

- **Pages**: Full-screen widgets representing app screens
- **Components**: Reusable UI elements (cards, buttons, custom widgets)
- **Services**: Business logic and data access patterns
- **Models**: Data structures representing domain entities
- **Utils**: Helper functions and utilities

### 2. Service Locator Pattern

The application uses a **global service instantiation** approach rather than dependency injection frameworks. Services are instantiated directly within the widgets that need them:

```dart
class MyPage extends StatefulWidget {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
}
```

**Rationale:**
- Simplicity without external dependencies
- Services manage their own Supabase client instance
- Single responsibility for each service

### 3. Imperative Navigation

Navigation is handled imperatively using Flutter's `Navigator` with named routes and the global navigator key:

```dart
// In main.dart
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

// In services/pages
appNavigatorKey.currentState?.pushNamed('/home');
```

**Rationale:**
- Direct control over navigation flow
- Ability to navigate from services or auth listeners
- Simpler than declarative routing frameworks

## Directory Structure

```
lib/
├── components/          # Reusable UI components
│   ├── badge_widget.dart
│   ├── lendable_card.dart
│   ├── user_card.dart
│   ├── profile_card.dart
│   ├── cached_avatar_widget.dart
│   ├── lazy_image_widget.dart
│   ├── connectivity_wrapper.dart
│   └── ...
├── config/             # Configuration and constants
│   ├── supabase_config.dart
│   └── constants.dart
├── l10n/               # Localization (i18n)
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   ├── app_localizations_de.dart
│   └── ...
├── models/             # Data models
│   ├── user_model.dart
│   ├── lendable_model.dart
│   ├── friend_request_model.dart
│   ├── category_model.dart
│   ├── group_model.dart
│   ├── badge_model.dart
│   └── ...
├── pages/              # Full-screen pages
│   ├── home.dart
│   ├── start/          # Main feed page
│   │   ├── start.dart
│   │   └── components/
│   ├── favorites.dart
│   ├── lendable.dart
│   ├── post_lendable/  # Article creation
│   │   ├── post_lendable.dart
│   │   └── components/
│   ├── post_lendable_success.dart
│   ├── private_profile.dart
│   ├── public_profile.dart
│   ├── login/
│   │   ├── pre_login.dart
│   │   ├── login.dart
│   │   ├── signup.dart
│   │   ├── auth_callback.dart
│   │   └── ...
│   ├── friends/
│   │   ├── friendlist.dart
│   │   └── components/
│   ├── groups/
│   │   ├── groups_page.dart
│   │   ├── group_detail_page.dart
│   │   └── ...
│   └── settings/
│       ├── settings.dart
│       ├── edit_profile.dart
│       ├── components/
│       └── ...
├── services/           # Business logic layer
│   ├── auth_service.dart
│   ├── user_service.dart
│   ├── lendable_service.dart
│   ├── friend_service.dart
│   └── ...
├── utils/              # Utility functions and helpers
│   ├── snackbar_utils.dart
│   ├── navigation_utils.dart
│   ├── location_utils.dart
│   └── ...
└── main.dart          # Application entry point
```

## Core Services

### AuthService
Handles user authentication (sign-up, sign-in, password reset, OTP verification).

**Key Methods:**
- `signup()` - Create new user account
- `signin()` - Sign in with email and password
- `signout()` - Sign out current user
- `resetPassword()` - Initiate password reset
- `verifyRecoveryCode()` - Verify recovery code

**Dependencies:** UserService, Supabase Auth

---

### UserService
Manages user profile data and user-related operations.

**Key Methods:**
- `getCurrentUserId()` - Get current authenticated user's ID
- `getUserById()` - Fetch user profile by ID
- `updateUserProfile()` - Update user information
- `getUsersByIds()` - Fetch multiple users

**Dependencies:** Supabase

---

### LendableService
Manages items/articles (creation, updates, deletion, queries).

**Key Methods:**
- `addLendable()` - Create new item
- `updateLendable()` - Update existing item
- `deleteLendable()` - Delete item
- `getLendables()` - Fetch items with filters
- `getLendableById()` - Fetch single item
- `getLendablesByUserId()` - Get all items by a user

**Dependencies:** UserService, FileService, Supabase

---

### FriendService
Manages friend relationships and friend requests.

**Key Methods:**
- `addFriend()` - Send friend request
- `acceptFriendRequest()` - Accept friend request
- `rejectFriendRequest()` - Reject friend request
- `removeFriend()` - Remove existing friend
- `getFriends()` - Get user's friends
- `getFriendRequests()` - Get pending friend requests

**Dependencies:** Supabase

---

### FavoriteService
Manages user's favorite items.

**Key Methods:**
- `addFavorite()` - Add item to favorites
- `removeFavorite()` - Remove item from favorites
- `getFavorites()` - Get user's favorite items
- `isFavorite()` - Check if item is favorited

**Dependencies:** Supabase

---

### FileService
Handles file uploads and management (images for items and avatars).

**Key Methods:**
- `uploadFile()` - Upload file to Supabase storage
- `deleteFile()` - Delete file from storage
- `getFileUrl()` - Get public URL for file

**Dependencies:** Supabase Storage

---

### GroupService
Manages user groups (creation, membership, queries).

**Key Methods:**
- `createGroup()` - Create new group
- `getGroups()` - Fetch groups
- `addMemberToGroup()` - Add user to group
- `removeMemberFromGroup()` - Remove user from group
- `getGroupMembers()` - Get members of a group

**Dependencies:** Supabase

## Data Models

### User Model
Represents a user account with profile information.

**Properties:**
- `id` - User ID (UUID)
- `email` - User email address
- `firstName` - User's first name
- `lastName` - User's last name (optional)
- `avatarUrl` - URL to user's avatar image
- `city` - User's city
- `postalCode` - User's postal code
- `created` - Account creation timestamp

---

### LendableModel
Represents an item that can be lent.

**Properties:**
- `id` - Item ID (UUID)
- `userId` - ID of item owner
- `title` - Item title
- `description` - Item description
- `category` - Item category
- `imageUrl` - URL to item image
- `isGift` - Whether item is available as gift
- `visibility` - Visibility mode ('all', 'friends', 'specific')
- `groupVisibility` - Group visibility setting
- `groupIds` - List of group IDs for specific visibility
- `latitude` - Item location latitude
- `longitude` - Item location longitude
- `created` - Item creation timestamp
- `updated` - Last update timestamp

---

### FriendRequest Model
Represents a friend request between two users.

**Properties:**
- `id` - Request ID (UUID)
- `requesterId` - User sending the request
- `receiverId` - User receiving the request
- `status` - Request status ('pending', 'accepted', 'rejected')
- `created` - Request creation timestamp

---

### GroupModel
Represents a user group.

**Properties:**
- `id` - Group ID (UUID)
- `name` - Group name
- `description` - Group description
- `ownerId` - Group owner's user ID
- `memberCount` - Number of group members
- `created` - Group creation timestamp

---

### BadgeModel
Represents achievement badges for users.

**Properties:**
- `id` - Badge ID
- `name` - Badge name
- `description` - Badge description
- `icon` - Badge icon identifier

## State Management Approach

The application uses **stateful widgets** with local state management:

```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _isLoading = false;
  List<Item> _items = [];
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      _items = await _service.getItems();
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
```

**Rationale:**
- No external state management dependencies
- Direct control over widget rebuilds
- Simple and predictable state flow
- Suitable for app's complexity level

## Database Schema (Supabase)

### Tables
- `users` - User profiles
- `lendables` - Items available for lending
- `lendable_groups` - Mapping of items to groups (for group-specific visibility)
- `friends` - Friend relationships
- `friend_requests` - Pending friend requests
- `favorites` - User favorites
- `groups` - User groups
- `group_members` - Mapping of users to groups
- `badges` - User achievement badges

### Real-time Features

- **Note:** Supabase Realtime is currently NOT used in this application. 
- Data is fetched on-demand using standard PostgreSQL queries.
- UI updates are triggered manually through `setState()` or page reloads.

## Key Features

### Authentication Flow
1. User signs up or logs in
2. AuthService communicates with Supabase Auth
3. UserService creates/loads user profile
4. Global auth state listener navigates to home
5. Auth token is managed by Supabase client

### Item Management Flow
1. User creates item via PostLendablePage
2. LendableService validates and uploads to Supabase
3. FileService handles image uploads
4. Item visibility rules applied (all/friends/specific groups)
5. Item appears in StartPage search and filter results

### Social Features
1. Friend requests initiated through FriendlistPage
2. FriendService manages request state
3. Users can accept/reject requests
4. Friends list updated after user actions or page refresh

## Localization (i18n)

The app supports English and German localization:

- **Localization Files:** `lib/l10n/app_localizations.dart` (auto-generated)
- **Source Files:** `.arb` files
- **Usage:** `AppLocalizations.of(context)!.stringKey`

**Important:** Only edit `.arb` source files, then run `flutter gen-l10n` to regenerate.

## Dependencies

Core dependencies (see `pubspec.yaml` for versions):
- `supabase_flutter` - Backend and authentication
- `flutter_localizations` - i18n support
- `http` - HTTP requests
- `flutter_svg` - SVG rendering
- `google_fonts` - Custom fonts
- `image_picker` - Image selection
- `cached_network_image` - Image caching
- `connectivity_plus` - Network detection
- `uuid` - UUID generation
- `share_plus` - Native share functionality
- `fluttertoast` - Toast notifications
- `visibility_detector` - Widget visibility detection

## Performance Considerations

1. **Image Caching:** `CachedNetworkImage` used for all network images
2. **Lazy Loading:** Images use `LazyImageWidget` for efficient loading
3. **Flat Widget Trees:** Pages are refactored to minimize nesting depth
4. **Const Constructors:** Used where possible to reduce rebuilds
5. **List Optimization:** Scrollable lists use efficient rendering

## Security

1. **Credentials:** Supabase configuration is managed in `lib/config/supabase_config.dart`.
2. **Authentication:** Supabase Auth handles secure token management.
3. **Authorization:** Database Row Level Security (RLS) policies enforced on backend.
4. **File Storage:** Supabase Storage with RLS for user-specific access.

## Testing Strategy

While comprehensive tests are not yet implemented, the architecture supports:
- **Unit Tests:** For service business logic
- **Widget Tests:** For component behavior
- **Integration Tests:** For API/database interactions

