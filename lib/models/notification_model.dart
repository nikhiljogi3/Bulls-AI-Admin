import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final List<String>
  recipientIds; // List of user IDs, empty list means all users
  final bool sendToAll;
  final DateTime createdAt;
  final String? imageUrl;
  final String? actionUrl;
  final String createdBy;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.recipientIds,
    required this.sendToAll,
    required this.createdAt,
    this.imageUrl,
    this.actionUrl,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'recipientIds': recipientIds,
      'sendToAll': sendToAll,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'createdBy': createdBy,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      recipientIds: List<String>.from(map['recipientIds'] ?? []),
      sendToAll: map['sendToAll'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      imageUrl: map['imageUrl'],
      actionUrl: map['actionUrl'],
      createdBy: map['createdBy'] ?? 'admin',
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    List<String>? recipientIds,
    bool? sendToAll,
    DateTime? createdAt,
    String? imageUrl,
    String? actionUrl,
    String? createdBy,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      recipientIds: recipientIds ?? this.recipientIds,
      sendToAll: sendToAll ?? this.sendToAll,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
