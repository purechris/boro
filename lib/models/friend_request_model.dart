import 'package:verleihapp/models/user_model.dart';

class FriendRequestModel {
  final String id;
  final String senderUserId;
  final String receiverUserId;
  final DateTime createdAt;
  UserModel? senderUser;
  UserModel? receiverUser;

  FriendRequestModel({
    required this.id,
    required this.senderUserId,
    required this.receiverUserId,
    required this.createdAt,
    this.senderUser,
    this.receiverUser,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json, String id) {
    return FriendRequestModel(
      id: id,
      senderUserId: json['sender_user_id'] as String,
      receiverUserId: json['receiver_user_id'] as String,
      createdAt: DateTime.parse(json['created'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_user_id': senderUserId,
      'receiver_user_id': receiverUserId,
      'created': createdAt.toUtc().toIso8601String(),
    };
  }

  // Setter-Methode für senderUser
  void setSenderUser(UserModel user) {
    senderUser = user;
  }

  // Setter-Methode für receiverUser
  void setReceiverUser(UserModel user) {
    receiverUser = user;
  }
  
}