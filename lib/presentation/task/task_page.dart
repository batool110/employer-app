import 'package:employer_test/presentation/widgets/theme/text_styles.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks', style: AppTextStyles.header)),
      body: const Center(
          child: Text('Task List Here', style: AppTextStyles.body)),
    );
  }
}
