import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all notifications
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .get();

      _notifications = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch notifications: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send notification to selected users or all users
  Future<void> sendNotification({
    required String title,
    required String message,
    required List<String> recipientIds,
    required bool sendToAll,
    String? imageUrl,
    String? actionUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final notification = NotificationModel(
        id: '',
        title: title,
        message: message,
        recipientIds: sendToAll ? [] : recipientIds,
        sendToAll: sendToAll,
        createdAt: DateTime.now(),
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        createdBy: 'admin',
      );

      // Add to notifications collection
      final docRef = await _firestore
          .collection('notifications')
          .add(notification.toMap());

      // Create user-specific notification records
      if (sendToAll) {
        // Get all users
        final usersSnapshot = await _firestore.collection('users').get();
        final batch = _firestore.batch();

        for (var userDoc in usersSnapshot.docs) {
          final userNotificationRef = _firestore
              .collection('users')
              .doc(userDoc.id)
              .collection('notifications')
              .doc(docRef.id);

          batch.set(userNotificationRef, {
            'notificationId': docRef.id,
            'title': title,
            'message': message,
            'imageUrl': imageUrl,
            'actionUrl': actionUrl,
            'isRead': false,
            'createdAt': Timestamp.fromDate(DateTime.now()),
          });
        }

        await batch.commit();
      } else {
        // Send to specific users
        final batch = _firestore.batch();

        for (var userId in recipientIds) {
          final userNotificationRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .doc(docRef.id);

          batch.set(userNotificationRef, {
            'notificationId': docRef.id,
            'title': title,
            'message': message,
            'imageUrl': imageUrl,
            'actionUrl': actionUrl,
            'isRead': false,
            'createdAt': Timestamp.fromDate(DateTime.now()),
          });
        }

        await batch.commit();
      }

      await fetchNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to send notification: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('notifications').doc(id).delete();
      await fetchNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete notification: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Get notification count for today
  int getTodayNotificationCount() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    return _notifications.where((notification) {
      return notification.createdAt.isAfter(todayStart);
    }).length;
  }

  // Get notification count for this week
  int getWeekNotificationCount() {
    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: 7));

    return _notifications.where((notification) {
      return notification.createdAt.isAfter(weekStart);
    }).length;
  }
}
