import 'package:employer_test/presentation/auth/auth_cubit.dart';
import 'package:employer_test/presentation/auth/login_page.dart';
import 'package:employer_test/presentation/widgets/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: appTheme,
        home: LoginPage(),
      ),
    );
  }
}
