import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/live_class_model.dart';

class LiveClassProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LiveClass> _liveClasses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<LiveClass> get liveClasses => _liveClasses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all live classes
  Future<void> fetchLiveClasses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('live_classes')
          .orderBy('startTime', descending: true)
          .get();

      _liveClasses = snapshot.docs
          .map((doc) => LiveClass.fromMap(doc.data(), doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch live classes: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stream live classes for real-time updates
  Stream<List<LiveClass>> streamLiveClasses() {
    return _firestore
        .collection('live_classes')
        .orderBy('startTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LiveClass.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Add a new live class
  Future<void> addLiveClass(LiveClass liveClass) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('live_classes').add(liveClass.toMap());
      await fetchLiveClasses();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add live class: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update an existing live class
  Future<void> updateLiveClass(String id, LiveClass liveClass) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore
          .collection('live_classes')
          .doc(id)
          .update(liveClass.toMap());
      await fetchLiveClasses();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update live class: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Start a live class (set isLive = true)
  Future<void> startLiveClass(String id) async {
    try {
      await _firestore.collection('live_classes').doc(id).update({
        'isLive': true,
      });
      await fetchLiveClasses();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to start live class: $e';
      notifyListeners();
      rethrow;
    }
  }

  // End a live class (set isLive = false)
  Future<void> endLiveClass(String id) async {
    try {
      await _firestore.collection('live_classes').doc(id).update({
        'isLive': false,
      });
      await fetchLiveClasses();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to end live class: $e';
      notifyListeners();
      rethrow;
    }
  }

  // Delete a live class
  Future<void> deleteLiveClass(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('live_classes').doc(id).delete();
      await fetchLiveClasses();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete live class: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
