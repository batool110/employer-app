import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String role,
    String? referredBy,
    XFile? picture,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = userCredential.user!.uid;

    String? pictureUrl;
    if (picture != null) {
      try {
        final ref = _storage.ref().child('user_pictures/$uid.jpg');
        final uploadTask = await ref.putFile(File(picture.path));

        // Ensure upload was successful before getting URL
        if (uploadTask.state == TaskState.success) {
          pictureUrl = await ref.getDownloadURL();
        } else {
          throw Exception('Upload failed: ${uploadTask.state}');
        }
      } catch (e) {
        print('Image upload or retrieval failed: $e');
        // Optionally: set a default picture URL or handle gracefully
      }
    }
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'referredBy': referredBy,
      'pictureUrl': pictureUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<String>> fetchAllUserNames() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<void> signOut() async => _auth.signOut();
}
