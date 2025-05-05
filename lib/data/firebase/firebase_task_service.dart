import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_test/domain/models/task_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseTaskService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> addTask(TaskModel task, File? imageFile) async {
    final ref = _storage.ref().child('task_images').child('${task.id}.jpg');
    String imageUrl = '';
    if (imageFile != null) {
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    await _firestore
        .collection('tasks')
        .doc(task.id)
        .set(task.copyWith(pictureUrl: imageUrl).toMap());
  }

  Future<List<TaskModel>> getTasks(String uid, String role) async {
    QuerySnapshot snapshot;
    if (role == 'employer') {
      snapshot = await _firestore.collection('tasks').get();
    } else {
      snapshot = await _firestore
          .collection('tasks')
          .where('assigneeId', isEqualTo: uid)
          .get();
    }
    return snapshot.docs
        .map((e) => TaskModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
    await _storage.ref().child('task_images').child('$taskId.jpg').delete();
  }

  Future<void> updateTask(TaskModel task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }
}
