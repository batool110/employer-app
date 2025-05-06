import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/firebase/firebase_auth_service.dart';
import 'package:image_picker/image_picker.dart';

class AuthCubit extends Cubit<bool> {
  final _authService = FirebaseAuthService();

  AuthCubit() : super(false);

  Future<void> login({
    required String email,
    required String password,
    required Function(String uid, String role) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        final uid = user.uid;
        final role = await _authService.getUserRole(uid);
        emit(true);
        onSuccess(uid, role);
      } else {
        onError('Login failed');
      }
    } catch (e) {
      onError(e.toString());
    }
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
    required Function(String uid) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final uid = await _authService.registerUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        role: role,
        referredBy: referredBy,
        picture: picture,
      );
      onSuccess(uid);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<List<String>> getAllUserNames() async {
    return await _authService.fetchAllUserNames();
  }
}
