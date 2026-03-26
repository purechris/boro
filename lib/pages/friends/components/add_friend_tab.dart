import 'package:flutter/material.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/models/friend_list_data.dart';
import 'package:verleihapp/models/friend_request_model.dart';
import 'package:verleihapp/components/user_card.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

/// Tab for adding friends and managing requests.
class AddFriendTab extends StatelessWidget {
  final TextEditingController emailController;
  final UserModel? currentUser;
  final bool isDemoUser;
  final Future<FriendListData> dataFuture;
  final VoidCallback onSendFriendRequest;
  final VoidCallback onShareFriendCode;
  final VoidCallback onCopyFriendCode;
  final Function(FriendRequestModel) onAcceptRequest;
  final Function(FriendRequestModel) onRejectRequest;
  final Function(FriendRequestModel) onCancelRequest;
  final RefreshCallback? onRefresh;

  const AddFriendTab({
    super.key,
    required this.emailController,
    required this.currentUser,
    required this.isDemoUser,
    required this.dataFuture,
    required this.onSendFriendRequest,
    required this.onShareFriendCode,
    required this.onCopyFriendCode,
    required this.onAcceptRequest,
    required this.onRejectRequest,
    required this.onCancelRequest,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddFriendSection(context),
            const SizedBox(height: 16),
            _buildFriendCodeSection(context),
            const SizedBox(height: 32),
            _buildFriendRequestsSection(context),
          ],
        ),
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: body,
      );
    }
    return body;
  }

  Widget _buildAddFriendSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.addFriends,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.friendCodeOrEmail,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          enabled: !isDemoUser,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isDemoUser ? null : onSendFriendRequest,
          child: Text(AppLocalizations.of(context)!.add),
        ),
      ],
    );
  }

  Widget _buildFriendCodeSection(BuildContext context) {
    final actualFriendCode = currentUser?.friendCode ?? AppLocalizations.of(context)!.loading;
    final hasFriendCode = currentUser?.friendCode != null && currentUser!.friendCode!.isNotEmpty;
    final displayFriendCode = isDemoUser ? '####-####' : actualFriendCode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.yourFriendCode,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      displayFriendCode,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: (hasFriendCode && !isDemoUser) ? onShareFriendCode : null,
                  icon: const Icon(Icons.share),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(12),
                  ),
                  tooltip: AppLocalizations.of(context)!.share,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: (hasFriendCode && !isDemoUser) ? onCopyFriendCode : null,
                  icon: const Icon(Icons.content_copy),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(12),
                  ),
                  tooltip: AppLocalizations.of(context)!.copy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendRequestsSection(BuildContext context) {
    return FutureBuilder<FriendListData>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(AppLocalizations.of(context)!.errorLoadingData));
        } else if (snapshot.hasData) {
          final sentRequests = snapshot.data!.sentRequests;
          final receivedRequests = snapshot.data!.receivedRequests;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (receivedRequests.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.receivedRequests,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildReceivedRequests(context, receivedRequests),
                const SizedBox(height: 32),
              ],
              if (sentRequests.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.sentRequests,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSentRequests(context, sentRequests),
              ],
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReceivedRequests(BuildContext context, List<FriendRequestModel> requests) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        final user = request.senderUser!;
        return UserCard(
          user: user,
          rightWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => onAcceptRequest(request),
                icon: const Icon(Icons.check, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(8),
                ),
                tooltip: AppLocalizations.of(context)!.accept,
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => onRejectRequest(request),
                icon: const Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(8),
                ),
                tooltip: AppLocalizations.of(context)!.reject,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSentRequests(BuildContext context, List<FriendRequestModel> requests) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        final user = request.receiverUser!;
        return UserCard(
          user: user,
          rightWidget: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'cancel') {
                onCancelRequest(request);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'cancel',
                child: Row(
                  children: [
                    const Icon(Icons.cancel_outlined, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.cancelRequest),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
