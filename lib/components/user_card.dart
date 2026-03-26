import 'package:flutter/material.dart';
import 'package:verleihapp/models/user_model.dart';
import 'package:verleihapp/utils/avatar_color_utils.dart';

/// A reusable user card component.
/// Displays the user's profile picture and name.
/// Supports optional right-side widgets for various actions.

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final Widget? rightWidget;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.rightWidget,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 60.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Profilbild
              AvatarColorUtils.createAvatar(
                name: user.firstName,
                imageUrl: user.imageUrl,
                radius: 24.0,
                iconSize: 24.0,
              ),
              const SizedBox(width: 16.0),
              // Name (vertikal zentriert)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.firstName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Rechtsseitiges Widget (optional)
              if (rightWidget != null) ...[
                const SizedBox(width: 8.0),
                rightWidget!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
