import 'dart:io';

import 'package:employer_test/domain/models/task_model.dart';
import 'package:employer_test/presentation/task/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class TaskEditPage extends StatefulWidget {
  final TaskModel task;
  final bool isEmployer;

  const TaskEditPage({super.key, required this.task, required this.isEmployer});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _rewardController;
  String? _selectedStatus;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _rewardController =
        TextEditingController(text: widget.task.reward.toString());
    _selectedStatus = widget.task.status;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TaskCubit>().editTask(
          taskId: widget.task.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          reward: double.tryParse(_rewardController.text.trim()) ?? 0,
          status: _selectedStatus ?? 'Pending',
          imageFile: _selectedImage,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              if (widget.isEmployer) ...[
                TextFormField(
                  controller: _rewardController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Reward Price'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
              ],
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(
                      value: 'In Progress', child: Text('In Progress')),
                  DropdownMenuItem(
                      value: 'Completed', child: Text('Completed')),
                ],
                onChanged: (val) => setState(() => _selectedStatus = val),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
