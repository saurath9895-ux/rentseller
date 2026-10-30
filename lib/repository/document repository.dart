import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class DocumentVerificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchSellerDocuments(String uid) async {
    var doc = await _firestore.collection("sellers").doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return doc.data();
    }
    return null;
  }

  Future<String?> uploadFileToStorage({
    required String uid,
    required String folderName,
    required dynamic pickedFile,
    required bool isWeb,
  }) async {
    try {
      final fileName = '$folderName/${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final supabaseClient = supabase.Supabase.instance.client;

      if (isWeb) {
        final bytes = await pickedFile.readAsBytes();
        await supabaseClient.storage.from('products').uploadBinary(
          fileName,
          bytes,
          fileOptions: const supabase.FileOptions(upsert: true, contentType: 'image/jpeg'),
        );
      } else {
        await supabaseClient.storage.from('products').upload(
          fileName,
          File(pickedFile.path),
          fileOptions: const supabase.FileOptions(upsert: true),
        );
      }

      return supabaseClient.storage.from('products').getPublicUrl(fileName);
    } catch (e) {
      debugPrint("Storage upload error: $e");
      return null;
    }
  }

  Future<void> updateSellerDocumentField(String uid, String firestoreField, String publicUrl) async {
    await _firestore.collection("sellers").doc(uid).set({
      firestoreField: publicUrl,
    }, SetOptions(merge: true));
  }
}