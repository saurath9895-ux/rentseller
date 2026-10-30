// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
//
// class ProductService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final supabase.SupabaseClient _supabase = supabase.Supabase.instance.client;
//
//   Future<String?> uploadImage(dynamic imageInput) async {
//     if (imageInput == null) return null;
//
//     final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
//
//     if (kIsWeb) {
//       final bytes = await (imageInput as XFile).readAsBytes();
//       await _supabase.storage.from('products').uploadBinary(
//         fileName,
//         bytes,
//         fileOptions: supabase.FileOptions(upsert: true, contentType: 'image/jpeg'),
//       );
//     } else {
//       await _supabase.storage.from('products').upload(
//         fileName,
//         imageInput as File,
//         fileOptions: supabase.FileOptions(upsert: true),
//       );
//     }
//
//     return _supabase.storage.from('products').getPublicUrl(fileName);
//   }
//
//   Future<String> addProductDocument({
//     required String sellerId,
//     required Map<String, dynamic> productData,
//   }) async {
//     DocumentReference docRef = await _firestore.collection("products").add(productData);
//     return docRef.id;
//   }
//
//   Future<String> createProductDocument({
//     required String sellerUid,
//     required String productName,
//     required String category,
//     required String rent,
//     required String security,
//     required String description,
//     required String pickup,
//     required String feature1,
//     required String feature2,
//     required String feature3,
//     required String feature4,
//     required String startDate,
//     required String endDate,
//     required String imageUrl,
//   }) async {
//     DocumentReference docRef = await _firestore.collection("products").add({
//       "sellerId": sellerUid,
//       "product": productName.trim(),
//       "category": category,
//       "rent": rent.trim(),
//       "securityDeposit": security.trim(),
//       "description": description.trim(),
//       "pickup": pickup.trim(),
//       "feature1": feature1.trim(),
//       "feature2": feature2.trim(),
//       "feature3": feature3.trim(),
//       "feature4": feature4.trim(),
//       "startDate": startDate.trim(),
//       "endDate": endDate.trim(),
//       "image": imageUrl,
//       "status": "Pending",
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//
//     return docRef.id;
//   }
// }