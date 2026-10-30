import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final supabase.SupabaseClient _supabase = supabase.Supabase.instance.client;

  Future<String?> uploadImageToSupabase(String uid, dynamic imageInput) async {
    try {
      if (imageInput == null) return null;

      final fileName = 'products/${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

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
      debugPrint("Supabase upload error: $e");
      return null;
    }
  }

  Future<String> addProductToFirestore(Map<String, dynamic> productData) async {
    DocumentReference docRef = await _firestore.collection('products').add(productData);
    return docRef.id;
  }

  Stream<DocumentSnapshot> getProductStream(String productId) {
    if (productId.isEmpty) return Stream.empty();
    return _firestore.collection('products').doc(productId).snapshots();
  }
}