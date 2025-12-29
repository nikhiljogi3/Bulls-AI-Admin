import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<AppUser> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppUser> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalUsers => _users.length;
  int get activeUsers => _users.where((u) => u.isActive).length;

  // Get new users registered in the last 30 days
  int get newUsersCount {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return _users.where((u) => u.createdAt.isAfter(thirtyDaysAgo)).length;
  }

  // Get users registered per month for the last 6 months
  Map<String, int> getUsersPerMonth() {
    final now = DateTime.now();
    final Map<String, int> monthlyData = {};

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = '${month.month}/${month.year}';
      monthlyData[monthKey] = 0;
    }

    for (var user in _users) {
      final monthKey = '${user.createdAt.month}/${user.createdAt.year}';
      if (monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = monthlyData[monthKey]! + 1;
      }
    }

    return monthlyData;
  }

  // Fetch all users
  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      _users = snapshot.docs
          .map((doc) => AppUser.fromMap(doc.data(), doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch users: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stream users for real-time updates
  Stream<List<AppUser>> streamUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppUser.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Add a new user
  Future<void> addUser(AppUser user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('users').add(user.toMap());
      await fetchUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add user: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update an existing user
  Future<void> updateUser(String id, AppUser user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('users').doc(id).update(user.toMap());
      await fetchUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update user: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Delete a user
  Future<void> deleteUser(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('users').doc(id).delete();
      await fetchUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete user: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Toggle user active status
  Future<void> toggleUserStatus(String id, bool isActive) async {
    try {
      await _firestore.collection('users').doc(id).update({
        'isActive': isActive,
      });
      await fetchUsers();
    } catch (e) {
      _errorMessage = 'Failed to toggle user status: $e';
      notifyListeners();
      rethrow;
    }
  }
}
