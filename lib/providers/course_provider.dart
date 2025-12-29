import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_bulls_asset/models/course_model.dart';

class CourseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Course> _courses = [];

  List<Course> get courses => _courses;

  /// -------------------------------
  /// FETCH COURSES
  /// -------------------------------
  Future<void> fetchCourses() async {
    try {
      final snapshot = await _firestore.collection('courses').get();

      _courses = snapshot.docs.map((doc) {
        return Course.fromJson({'id': doc.id, ...doc.data()});
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Fetch Courses Error: $e");
      rethrow;
    }
  }

  /// -------------------------------
  /// ADD COURSE
  /// -------------------------------
  Future<void> addCourse(Course course) async {
    try {
      final docRef = _firestore.collection('courses').doc(course.id);

      await docRef.set({
        'id': course.id,
        'title': course.title,
        'description': course.description,
        'imageUrl': course.imageUrl,
        'videos': course.videos.map((v) => v.toJson()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _courses.add(course);
      notifyListeners();
    } catch (e) {
      debugPrint("Add Course Error: $e");
      rethrow;
    }
  }

  /// -------------------------------
  /// UPDATE COURSE
  /// -------------------------------
  Future<void> updateCourse(Course course) async {
    try {
      await _firestore.collection('courses').doc(course.id).update({
        'title': course.title,
        'description': course.description,
        'imageUrl': course.imageUrl,
        'videos': course.videos.map((v) => v.toJson()).toList(),
      });

      final index = _courses.indexWhere((c) => c.id == course.id);
      if (index != -1) {
        _courses[index] = course;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Update Course Error: $e");
      rethrow;
    }
  }

  /// -------------------------------
  /// DELETE COURSE
  /// -------------------------------
  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('courses').doc(courseId).delete();

      _courses.removeWhere((c) => c.id == courseId);

      if (hasListeners) {
        notifyListeners();
      }
    } on FirebaseException catch (e) {
      debugPrint("🔥 Firebase Delete Error");
      debugPrint("Code: ${e.code}");
      debugPrint("Message: ${e.message}");
    } catch (e) {
      debugPrint("❌ Delete Course Error: $e");
    }
  }
}
