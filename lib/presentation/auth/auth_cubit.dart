import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/firebase/firebase_auth_service.dart';
import 'package:image_picker/image_picker.dart';

class AuthCubit extends Cubit<bool> {
  final _authService = FirebaseAuthService();

  AuthCubit() : super(false);

  void login(String email, String password) async {
    final user = await _authService.signIn(email, password);
    if (user != null) emit(true);
  }

  void logout() async {
    await _authService.signOut();
    emit(false);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String role,
    String? referredBy,
    XFile? picture,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await _authService.registerUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        role: role,
        referredBy: referredBy,
        picture: picture,
      );
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<List<String>> getAllUserNames() async {
    return await _authService.fetchAllUserNames();
  }
}
