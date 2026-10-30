import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final supabase.SupabaseClient _supabase = supabase.Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchSellerData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection("sellers").doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> updateSellerData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection("sellers").doc(uid).set(data, SetOptions(merge: true));
  }

  Future<String?> uploadImageToStorage(String folderName, String uid, dynamic imageInput) async {
    final fileName = '$folderName/${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (kIsWeb) {
      final bytes = await (imageInput as XFile).readAsBytes();
      await _supabase.storage.from('products').uploadBinary(
        fileName,
        bytes,
        fileOptions: supabase.FileOptions(upsert: true, contentType: 'image/jpeg'),
      );
    } else {
      await _supabase.storage.from('products').upload(
        fileName,
        imageInput as File,
        fileOptions: supabase.FileOptions(upsert: true),
      );
    }

    return _supabase.storage.from('products').getPublicUrl(fileName);
  }

  Stream<DocumentSnapshot> streamSellerData(String uid) {
    if (uid.isEmpty) return const Stream.empty();
    return _firestore.collection("sellers").doc(uid).snapshots();
  }
}