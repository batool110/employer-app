import 'package:employer_test/presentation/auth/auth_cubit.dart';
import 'package:employer_test/presentation/task/task_page.dart';
import 'package:employer_test/presentation/widgets/button.dart';
import 'package:employer_test/presentation/widgets/text_field.dart';
import 'package:employer_test/presentation/widgets/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'Employee';
  String referredBy = 'None';
  XFile? picture;

  final List<String> roles = ['Employer', 'Employee'];
  List<String> existingUsers = ['None'];

  @override
  void initState() {
    super.initState();
    loadExistingUsers();
  }

  Future<void> loadExistingUsers() async {
    final cubit = context.read<AuthCubit>();
    final users = await cubit.getAllUserNames();
    setState(() {
      existingUsers = ['None', ...users];
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => picture = picked);
    }
  }

  void registerUser() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
            phone: phoneController.text.trim(),
            address: addressController.text.trim(),
            role: role,
            referredBy: referredBy == 'None' ? null : referredBy,
            picture: picture,
            onSuccess: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const TaskPage())),
            onError: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Register', style: AppTextStyles.header)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  label: 'Name',
                  controller: nameController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Name required' : null,
                ),
                CustomTextField(
                  label: 'Email',
                  controller: emailController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Email required' : null,
                ),
                CustomTextField(
                  label: 'Phone',
                  controller: phoneController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Phone required' : null,
                ),
                CustomTextField(
                  label: 'Address',
                  controller: addressController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Address required'
                      : null,
                ),
                CustomTextField(
                  label: 'Password',
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: role,
                  items: roles
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => role = value!),
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                DropdownButtonFormField<String>(
                  value: referredBy,
                  items: existingUsers
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => referredBy = value!),
                  decoration: const InputDecoration(labelText: 'Referred By'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: Text(
                      picture == null ? 'Upload Picture' : 'Change Picture'),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Register',
                  onPressed: registerUser,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
