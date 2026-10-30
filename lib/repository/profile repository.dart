import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../services/profile.dart';

class ProfileRepository {
  final ProfileService _service = ProfileService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchProfileDoc(String uid) async {
    var doc = await _firestore.collection("sellers").doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return doc.data();
    }
    return null;
  }

  Future<Map<String, dynamic>?> getSellerProfile(String uid) async {
    var profile = await _service.fetchSellerData(uid);
    if (profile != null) {
      return profile;
    }
    return await fetchProfileDoc(uid);
  }

  Future<bool> saveProfile(String uid, Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> updatedData = {
        ...data,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      try {
        await _service.updateSellerData(uid, updatedData);
      } catch (_) {
        await _firestore.collection("sellers").doc(uid).set(updatedData, SetOptions(merge: true));
      }
      return true;
    } catch (e) {
      debugPrint("Error saving profile: $e");
      return false;
    }
  }

  Future<String?> uploadSellerImage(String folder, String uid, dynamic image) async {
    return await _service.uploadImageToStorage(folder, uid, image);
  }

  Future<String?> uploadImage({
    required String uid,
    required dynamic pickedFile,
    required bool isWeb,
  }) async {
    try {
      final fileName = 'profiles/${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final supabaseClient = supabase.Supabase.instance.client;

      if (isWeb) {
        Uint8List bytes;
        if (pickedFile is Uint8List) {
          bytes = pickedFile;
        } else if (pickedFile is XFile) {
          bytes = await pickedFile.readAsBytes();
        } else {
          return null;
        }

        await supabaseClient.storage.from('products').uploadBinary(
          fileName,
          bytes,
          fileOptions: supabase.FileOptions(upsert: true, contentType: 'image/jpeg'),
        );
      } else {
        File file;
        if (pickedFile is File) {
          file = pickedFile;
        } else if (pickedFile is XFile) {
          file = File(pickedFile.path);
        } else {
          return null;
        }

        await supabaseClient.storage.from('products').upload(
          fileName,
          file,
          fileOptions: supabase.FileOptions(upsert: true),
        );
      }

      return supabaseClient.storage.from('products').getPublicUrl(fileName);
    } catch (e) {
      debugPrint("Profile image upload error: $e");
      return null;
    }
  }

  Stream<DocumentSnapshot> getSellerStream(String uid) {
    return _service.streamSellerData(uid);
  }

  Future<void> updateProfileImageField(String uid, String publicUrl) async {
    await _firestore.collection("sellers").doc(uid).set({
      "profileImage": publicUrl,
    }, SetOptions(merge: true));
  }

  Future<bool> updateProfileData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection("sellers").doc(uid).set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }
}