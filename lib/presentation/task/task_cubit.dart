import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_test/domain/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/firebase/firebase_task_service.dart';

class TaskCubit extends Cubit<List<TaskModel>> {
  final FirebaseTaskService _taskService;

  TaskCubit({required FirebaseTaskService firebaseTaskService})
      : _taskService = firebaseTaskService,
        super([]);

  Future<List<Map<String, String>>> getEmployees() async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Employee')
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return {
        'uid': doc.id,
        'name': (data['name'] ?? 'Unknown').toString(),
      };
    }).toList();
  }

  Future<void> loadTasks(String uid, String role) async {
    final tasks = await _taskService.getTasks(uid, role);
    emit(tasks);
  }

  Future<void> addTask(TaskModel task, File? imageFile) async {
    await _taskService.addTask(task, imageFile);
    await loadTasks(task.createdBy, 'employer');
  }

  Future<void> deleteTask(String taskId) async {
    await _taskService.deleteTask(taskId);
    emit(state.where((t) => t.id != taskId).toList());
  }

  Future<void> updateTask(TaskModel updatedTask, File? imageFile) async {
    await _taskService.updateTask(updatedTask, imageFile);
    emit(state.map((t) => t.id == updatedTask.id ? updatedTask : t).toList());
  }

  Future<void> editTask({
    required String taskId,
    required String title,
    required String description,
    required double reward,
    required String status,
    File? imageFile,
  }) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final updatedTask = TaskModel(
      id: task.id,
      title: title,
      description: description,
      pictureUrl: task.pictureUrl,
      assigneeId: task.assigneeId,
      status: status,
      reward: reward,
      createdBy: task.createdBy,
    );

    await updateTask(updatedTask, imageFile);
  }
}
