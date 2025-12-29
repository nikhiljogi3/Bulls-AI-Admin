import 'package:cloud_firestore/cloud_firestore.dart';

class LiveClass {
  final String id;
  final String title;
  final String instructor;
  final String roomId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isLive;
  final DateTime createdAt;

  LiveClass({
    required this.id,
    required this.title,
    required this.instructor,
    required this.roomId,
    required this.startTime,
    required this.endTime,
    this.isLive = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert LiveClass to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'instructor': instructor,
      'roomId': roomId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'isLive': isLive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create LiveClass from Firestore document
  factory LiveClass.fromMap(Map<String, dynamic> map, String id) {
    return LiveClass(
      id: id,
      title: map['title'] ?? '',
      instructor: map['instructor'] ?? '',
      roomId: map['roomId'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      isLive: map['isLive'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Copy with method for updates
  LiveClass copyWith({
    String? id,
    String? title,
    String? instructor,
    String? roomId,
    DateTime? startTime,
    DateTime? endTime,
    bool? isLive,
    DateTime? createdAt,
  }) {
    return LiveClass(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      roomId: roomId ?? this.roomId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isLive: isLive ?? this.isLive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
