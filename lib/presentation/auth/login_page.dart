import 'package:employer_test/presentation/auth/auth_cubit.dart';
import 'package:employer_test/presentation/auth/register_page.dart';
import 'package:employer_test/presentation/task/task_page.dart';
import 'package:employer_test/presentation/widgets/button.dart';
import 'package:employer_test/presentation/widgets/text_field.dart';
import 'package:employer_test/presentation/widgets/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login', style: AppTextStyles.header)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(label: 'Email', controller: emailController),
            CustomTextField(
                label: 'Password',
                controller: passwordController,
                isPassword: true),
            PrimaryButton(
              label: 'Login',
              onPressed: () {
                context
                    .read<AuthCubit>()
                    .login(emailController.text, passwordController.text);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Already have an account?',
                    style: AppTextStyles.body,
                  ),
                  PrimartTextButton(
                      label: 'Register',
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterPage()));
                      })
                ],
              ),
            ),
            BlocBuilder<AuthCubit, bool>(
              builder: (context, loggedIn) {
                if (loggedIn) {
                  Future.microtask(() => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const TaskPage()),
                      ));
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
