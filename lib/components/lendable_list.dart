import 'package:flutter/material.dart';
import 'package:verleihapp/models/lendable_model.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/components/lendable_card.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class LendableList extends StatelessWidget {
  final Future<List<Map<LendableModel, UserModel>>>? lendablesFuture;
  final List<Map<LendableModel, UserModel>>? lendables;
  final String? title;
  final int? itemCount;
  final bool showMenu;
  final bool hideUserName;
  final void Function(bool success, String? error)? onDelete;
  final VoidCallback? onBorrowChanged;
  final VoidCallback? onReturnFromDetail;
  final Widget? emptyState;

  const LendableList({
    super.key,
    this.lendablesFuture,
    this.lendables,
    this.title,
    this.itemCount,
    this.showMenu = false,
    this.hideUserName = false,
    this.onDelete,
    this.onBorrowChanged,
    this.onReturnFromDetail,
    this.emptyState,
  }) : assert(lendablesFuture != null || lendables != null, 'Either lendablesFuture or lendables must be provided');

  @override
  Widget build(BuildContext context) {
    if (lendables != null) {
      return _buildContent(context, lendables!);
    }

    return FutureBuilder<List<Map<LendableModel, UserModel>>>(
      future: lendablesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(AppLocalizations.of(context)!.errorLoadingData));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return emptyState ?? Center(child: Text(AppLocalizations.of(context)!.noItemsFound));
        } else {
          return _buildContent(context, snapshot.data!);
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, List<Map<LendableModel, UserModel>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              _buildTitleWithCount(data),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
        _buildLendableList(data),
      ],
    );
  }

  String _buildTitleWithCount(List<Map<LendableModel, UserModel>> data) {
    final count = itemCount ?? data.length;
    return '$title ($count)';
  }

  Widget _buildLendableList(List<Map<LendableModel, UserModel>> lendablesWithUsers) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: lendablesWithUsers.length,
      padding: EdgeInsets.only(left: 10, right: 10),
      separatorBuilder: (context, index) => SizedBox(height: 3),
      itemBuilder: (context, index) {
        final lendableUserMap = lendablesWithUsers[index];
        final lendable = lendableUserMap.keys.first;
        final user = lendableUserMap.values.first;
        return LendableCard(
          lendable: lendable, 
          user: user,
          showMenu: showMenu,
          hideUserName: hideUserName,
          onDelete: onDelete,
          onBorrowChanged: onBorrowChanged,
          onReturnFromDetail: onReturnFromDetail,
        );
      },
    );
  }
}