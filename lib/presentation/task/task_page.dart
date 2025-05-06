import 'dart:io';

import 'package:employer_test/domain/models/task_model.dart';
import 'package:employer_test/presentation/task/task_cubit.dart';
import 'package:employer_test/presentation/widgets/theme/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class TaskPage extends StatelessWidget {
  final String uid;
  final String role;
  const TaskPage({required this.uid, required this.role, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks $uid')),
      body: BlocBuilder<TaskCubit, List<TaskModel>>(
        builder: (context, tasks) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                leading: Image.network(task.pictureUrl,
                    width: 50, height: 50, fit: BoxFit.cover),
                title: Text(task.title),
                subtitle: Text(
                    'Reward: \$${task.reward.toStringAsFixed(2)} | Status: ${task.status}'),
                trailing: role == 'employer' && task.assigneeId.isEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editTask(context, task),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                context.read<TaskCubit>().deleteTask(task.id),
                          ),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: role == 'Employer'
          ? FloatingActionButton(
              onPressed: () => _addTask(context),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _addTask(BuildContext context) {
    showTaskBottomSheet(context);
  }

  void _editTask(BuildContext context, TaskModel task) {
    showTaskBottomSheet(context, task: task);
  }

  void showTaskBottomSheet(BuildContext context, {TaskModel? task}) async {
    final taskCubit = context.read<TaskCubit>();
    final isEditing = task != null;

    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController =
        TextEditingController(text: task?.description ?? '');
    final rewardController = TextEditingController(
      text: task != null ? task.reward.toString() : '',
    );
    String status = task?.status ?? 'Pending';
    String? assigneeId = task?.assigneeId;
    File? imageFile;
    final picker = ImagePicker();

    // ✅ Perform async work BEFORE using `context` in builder
    List<Map<String, String>> employees = [];
    if (context.mounted && role == 'Employer') {
      employees = await taskCubit.getEmployees();
    }

    // ✅ Now it's safe to use context inside builder
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEditing ? 'Edit Task' : 'Add Task',
                    style: Theme.of(ctx).textTheme.headline6),
                const SizedBox(height: 16),
                TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title')),
                TextField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Description')),
                TextField(
                  controller: rewardController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Reward'),
                ),
                const SizedBox(height: 8),
                if (role == 'Employer')
                  DropdownButtonFormField<String>(
                    value: assigneeId,
                    items: employees.map((e) {
                      return DropdownMenuItem(
                        value: e['uid'],
                        child: Text(e['name']!),
                      );
                    }).toList(),
                    onChanged: (value) => assigneeId = value!,
                    decoration: const InputDecoration(labelText: 'Assign to'),
                  ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) imageFile = File(picked.path);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final desc = descriptionController.text.trim();
                    final reward =
                        double.tryParse(rewardController.text) ?? 0.0;

                    if (title.isEmpty || desc.isEmpty || reward <= 0) return;

                    final newTask = TaskModel(
                      id: isEditing ? task.id : const Uuid().v4(),
                      title: title,
                      description: desc,
                      pictureUrl: isEditing ? task.pictureUrl : '',
                      assigneeId: assigneeId ?? '',
                      status: status,
                      reward: reward,
                      createdBy: uid,
                    );

                    if (isEditing) {
                      taskCubit.updateTask(newTask, imageFile);
                    } else {
                      taskCubit.addTask(newTask, imageFile!);
                    }

                    Navigator.pop(ctx); // ✅ Use local context inside builder
                  },
                  child: Text(isEditing ? 'Update Task' : 'Add Task'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
