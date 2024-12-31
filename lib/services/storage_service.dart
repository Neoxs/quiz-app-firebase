import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image
  Future<String> uploadImage(File imageFile, String userId) async {
    String fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
    Reference storageRef = _storage.ref().child('images/$fileName');
    
    try {
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload error: $e');
      throw Exception('Failed to upload image');
    }
  }

  // Upload avatar
  Future<String> uploadAvatar(File imageFile, String userId) async {
    String fileName = 'avatar_$userId${path.extension(imageFile.path)}';
    Reference storageRef = _storage.ref().child('avatars/$fileName');
    
    try {
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload error: $e');
      throw Exception('Failed to upload avatar');
    }
  }
}