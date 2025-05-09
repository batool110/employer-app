import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_test/data/firebase/local_notification_service.dart';
import 'package:employer_test/domain/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseNotificationService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _taskCollection = 'tasks';

  final Set<String> _seenTaskIds = {};

  Future<void> checkForTaskAssignments() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection(_taskCollection)
        .where('assigneeId', isEqualTo: user.uid)
        .get();

    for (var doc in snapshot.docs) {
      final task = TaskModel.fromMap(doc.data());
      if (!_seenTaskIds.contains(task.id)) {
        _seenTaskIds.add(task.id);
        _notify(task);
      }
    }
  }

  void _notify(TaskModel task) {
    LocalNotificationService.showNotification(
      title: 'New Task Assigned',
      body: task.title,
      payload: task.id,
    );
  }
}
