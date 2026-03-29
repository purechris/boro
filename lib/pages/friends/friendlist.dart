import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:verleihapp/models/friend_request_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/pages/public_profile.dart';
import 'package:verleihapp/services/friend_service.dart';
import 'package:verleihapp/services/user_service.dart';
import 'package:verleihapp/utils/snackbar_utils.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'package:verleihapp/models/friend_list_data.dart';
import 'package:verleihapp/pages/friends/components/friend_list_tab.dart';
import 'package:verleihapp/pages/friends/components/add_friend_tab.dart';

class FriendlistPage extends StatefulWidget {
  const FriendlistPage({super.key});

  @override
  State<FriendlistPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendlistPage> with SingleTickerProviderStateMixin {
  // Services
  final FriendService _friendService = FriendService();
  final UserService _userService = UserService();
  
  // State
  late Future<FriendListData> _dataFuture = _getData();
  late TabController _tabController;
  final TextEditingController _friendCodeController = TextEditingController();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    setState(() {
      _dataFuture = _getData().then((data) {
        // Setze aktuellen User aus den geladenen Daten
        if (data.currentUser != null) {
          _currentUser = data.currentUser;
          if (mounted) {
            setState(() {});
          }
        }
        return data;
      });
    });
  }

  Future<FriendListData> _getData() async {
    final user = await _userService.getCurrentUser();
    if (user?.id != null) {
      final userId = user!.id!;
      final friends = await _friendService.getFriends(userId);
      final sentRequests = await _friendService.getSentFriendRequests(userId);
      final receivedRequests = await _friendService.getReceivedFriendRequests(userId);
      return FriendListData(
        currentUser: user,
        friends: friends,
        sentRequests: sentRequests,
        receivedRequests: receivedRequests,
      );
    }
    return FriendListData.empty();
  }

  Future<void> _handleRefresh() async {
    _loadData();
    await _dataFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            FriendListTab(
              dataFuture: _dataFuture,
              isDemoUser: _userService.isDemoUser(),
              onRemoveFriend: (friend) => _showDeleteConfirmationDialog(friend),
              onNavigateToProfile: _navigateToPublicProfile,
              onAddFriendsNow: () => _tabController.animateTo(1),
              onRefresh: _handleRefresh,
            ),
            AddFriendTab(
              emailController: _friendCodeController,
              currentUser: _currentUser,
              isDemoUser: _userService.isDemoUser(),
              dataFuture: _dataFuture,
              onSendFriendRequest: _sendFriendRequest,
              onShareFriendCode: _shareFriendCode,
              onCopyFriendCode: _copyFriendCodeToClipboard,
              onRefresh: _handleRefresh,
              onAcceptRequest: (request) async {
                final l10n = AppLocalizations.of(context)!;
                await _friendService.acceptFriendRequest(request.id);
                if (!context.mounted) return;
                _loadData();
                SnackbarUtils.showSuccess(context, l10n.requestAccepted);
              },
              onRejectRequest: (request) => _showRejectConfirmationDialog(request, request.senderUser!),
              onCancelRequest: (request) => _showCancelConfirmationDialog(request, request.receiverUser!),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.friends),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.yourFriends),
          FutureBuilder<FriendListData>(
            future: _dataFuture,
            builder: (context, snapshot) {
              int requestCount = 0;
              if (snapshot.hasData) {
                requestCount = snapshot.data!.receivedRequests.length;
              }
              return Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.addFriendsTab),
                    if (requestCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$requestCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(UserModel friend) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.removeFriendTitle),
        content: Text(AppLocalizations.of(context)!.removeFriendConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.remove),
          ),
        ],
      ),
    );

    if (confirm == true && friend.id != null) {
      await _friendService.removeFriend((await _userService.getCurrentUser())!.id!, friend.id!);
      _loadData();
    }
  }

  Future<void> _showCancelConfirmationDialog(FriendRequestModel request, UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.cancelRequestTitle),
        content: Text(AppLocalizations.of(context)!.cancelFriendRequestConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.cancelRequest),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _friendService.cancelFriendRequest(request.id);
        if (!mounted) return;
        _loadData();
        SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.requestCancelled);
      } catch (e) {
        if (!mounted) return;
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
  }

  Future<void> _showRejectConfirmationDialog(FriendRequestModel request, UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.rejectRequestTitle),
        content: Text(AppLocalizations.of(context)!.rejectFriendRequestConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.rejectRequest),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _friendService.rejectFriendRequest(request.id);
        if (!mounted) return;
        _loadData();
        SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.requestRejected);
      } catch (e) {
        if (!mounted) return;
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
      }
    }
  }

  Future<void> _sendFriendRequest() async {
    final input = _friendCodeController.text.trim();
    if (input.isEmpty) {
      return;
    }

    try {
      final l10n = AppLocalizations.of(context)!;

      // Check if the input is a friend code (Format: XX##-XX## or XX##XX##)
      final normalizedInput = input.toUpperCase().replaceAll(' ', '').replaceAll('-', '');
      final isFriendCode = normalizedInput.length == 8 && 
                          RegExp(r'^[A-Z]{2}\d{2}[A-Z]{2}\d{2}$').hasMatch(normalizedInput);
      
      if (!isFriendCode) {
        SnackbarUtils.showError(context, l10n.errorOccurred);
        return;
      }

      await _friendService.createFriendRequestByCode(input);
      if (!mounted) return;
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.requestSent);
      _loadData();
      _friendCodeController.clear();
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final errorString = e.toString();
      if (errorString.contains('Friend request already exists')) {
        SnackbarUtils.showError(context, l10n.friendRequestAlreadyExists);
      } else {
        SnackbarUtils.showError(context, l10n.errorOccurred);
      }
    }
  }

  Future<void> _copyFriendCodeToClipboard() async {
    try {
      final friendCode = _currentUser?.friendCode;
      final l10n = AppLocalizations.of(context)!;
      if (friendCode == null || friendCode.isEmpty) {
        SnackbarUtils.showError(context, l10n.errorOccurred);
        return;
      }
      
      await Clipboard.setData(ClipboardData(text: friendCode));
      if (!mounted) return;
      SnackbarUtils.showSuccess(context, l10n.friendCodeCopied);
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
    }
  }

  Future<void> _shareFriendCode() async {
    try {
      final friendCode = _currentUser?.friendCode;
      if (friendCode == null || friendCode.isEmpty) {
        SnackbarUtils.showError(context, AppLocalizations.of(context)!.errorOccurred);
        return;
      }
      
      final String shareText = 'Hey! 👋\n\n'
          'Du kannst mich bei der Boro-App mit diesem Code als Freund hinzufügen:\n\n'
          '$friendCode\n\n'
          'Boro ist eine App zum Teilen und Verleihen mit Freunden. '
          'Weitere Infos findest du auf https://boro-app.de';
      
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
        ),
      );
    } catch (_) {
    }
  }

  void _navigateToPublicProfile(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublicProfilePage(userId: user.id!),
      ),
    );
  }
}
