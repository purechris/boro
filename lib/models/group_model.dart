import 'package:verleihapp/models/user_model.dart';

class GroupModel {
  final String? id;
  final String name;
  final String? description;
  final String groupCode;
  final String? icon; // Corresponds to the 'icon' column in SQL
  final DateTime created;
  
  // The role of the current user in this group (from group_members)
  final String? currentUserRole;

  GroupModel({
    this.id,
    required this.name,
    this.description,
    required this.groupCode,
    required this.created,
    this.icon,
    this.currentUserRole,
  });

  // Helper method to check if the current user is an admin
  bool get isAdmin => currentUserRole == 'admin';

  // Konvertierung von JSON (Supabase)
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      groupCode: json['group_code'] as String,
      icon: json['icon'] as String?,
      created: DateTime.parse(json['created'] as String).toLocal(),
      currentUserRole: json['currentUserRole'] as String?,
    );
  }

  // Konvertierung zu JSON (für Supabase Insert/Update)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'group_code': groupCode,
      'icon': icon,
      'created': created.toUtc().toIso8601String(),
    };
  }
}

class GroupMemberModel {
  final String groupId;
  final String userId;
  final String role; // 'admin' oder 'member'
  final DateTime joinedAt;
  final UserModel? user; // Optionales Profil-Objekt

  GroupMemberModel({
    required this.groupId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    this.user,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json, {UserModel? user}) {
    return GroupMemberModel(
      groupId: json['group_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String).toLocal(),
      user: user,
    );
  }
}
