import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/models/friend_request_model.dart';

/// DTO representing the data needed for the friend list page.
class FriendListData {
  final UserModel? currentUser;
  final List<UserModel> friends;
  final List<FriendRequestModel> sentRequests;
  final List<FriendRequestModel> receivedRequests;
  final List<UserModel> suggestions;

  const FriendListData({
    this.currentUser,
    this.friends = const [],
    this.sentRequests = const [],
    this.receivedRequests = const [],
    this.suggestions = const [],
  });

  /// Creates an empty [FriendListData].
  factory FriendListData.empty() {
    return const FriendListData();
  }

  FriendListData copyWith({
    UserModel? currentUser,
    List<UserModel>? friends,
    List<FriendRequestModel>? sentRequests,
    List<FriendRequestModel>? receivedRequests,
    List<UserModel>? suggestions,
  }) {
    return FriendListData(
      currentUser: currentUser ?? this.currentUser,
      friends: friends ?? this.friends,
      sentRequests: sentRequests ?? this.sentRequests,
      receivedRequests: receivedRequests ?? this.receivedRequests,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  bool get isEmpty =>
      currentUser == null &&
      friends.isEmpty &&
      sentRequests.isEmpty &&
      receivedRequests.isEmpty &&
      suggestions.isEmpty;
}
