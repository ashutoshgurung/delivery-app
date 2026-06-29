import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage({
    required File imageFile,
    required String uid,
  }) async {
    final ref = _storage.ref().child('profile_images/$uid.jpg');

    await ref.putFile(imageFile);

    return await ref.getDownloadURL();
  }
}