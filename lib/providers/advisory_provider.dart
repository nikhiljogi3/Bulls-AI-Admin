import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_admin_bulls_asset/models/advisory_model.dart';

class AdvisoryProvider with ChangeNotifier {
  final _collection = FirebaseFirestore.instance.collection('advisory_tips');

  final List<AdvisoryTip> _tips = [];
  bool _isLoading = false;
  String? _error;

  List<AdvisoryTip> get tips => List.unmodifiable(_tips);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final snapshot = await _collection
          .orderBy('publishedAt', descending: true)
          .get();
      _tips
        ..clear()
        ..addAll(snapshot.docs.map((d) => AdvisoryTip.fromMap(d.data(), d.id)));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTip(AdvisoryTip tip) async {
    await _collection.add(tip.toMap());
    await fetchTips();
  }

  Future<void> updateTip(AdvisoryTip tip) async {
    await _collection.doc(tip.id).set(tip.toMap(), SetOptions(merge: true));
    await fetchTips();
  }

  Future<void> deleteTip(String id) async {
    await _collection.doc(id).delete();
    _tips.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<int> pruneOldTips({DateTime? before}) async {
    final cutoff = (before ?? DateTime.now().toUtc()).toIso8601String();
    final query = await _collection
        .where('expiresAt', isLessThan: cutoff)
        .get();
    int count = 0;
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
      count++;
    }
    if (count > 0) {
      await batch.commit();
    }
    await fetchTips();
    return count;
  }
}
