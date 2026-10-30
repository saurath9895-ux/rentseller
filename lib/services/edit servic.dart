import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class ProductEditService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final supabase.SupabaseClient _supabase = supabase.Supabase.instance.client;

  Future<String?> uploadImage(String uid, dynamic imageInput) async {
    try {
      if (imageInput == null) return null;
      final fileName = 'products/edit_${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (kIsWeb) {
        Uint8List bytes = imageInput is Uint8List ? imageInput : await (imageInput as XFile).readAsBytes();
        await _supabase.storage.from('products').uploadBinary(
          fileName,
          bytes,
          fileOptions: supabase.FileOptions(upsert: true, contentType: 'image/jpeg'),
        );
      } else {
        File file = imageInput is File ? imageInput : File((imageInput as XFile).path);
        await _supabase.storage.from('products').upload(
          fileName,
          file,
          fileOptions: supabase.FileOptions(upsert: true),
        );
      }
      return _supabase.storage.from('products').getPublicUrl(fileName);
    } catch (e) {
      debugPrint("Error updating image: $e");
      return null;
    }
  }

  Future<void> updateFirestoreData(String productId, Map<String, dynamic> data) async {
    await _firestore.collection('products').doc(productId).update(data);
  }
}