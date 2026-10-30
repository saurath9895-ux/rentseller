import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../repository/productrepository.dart';

class AddProductViewModel extends ChangeNotifier {
  bool isUploading = false;
  final ProductRepository _repository = ProductRepository();

  Future<String?> uploadImageOnly(String uid, dynamic imagePayload) async {
    isUploading = true;
    notifyListeners();
    try {
      return await _repository.uploadImageToSupabase(uid, imagePayload);
    } catch (e) {
      debugPrint("Image upload error: $e");
      return null;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<String?> publishProduct({
    required String productName,
    required String category,
    required String rent,
    required String security,
    required String description,
    required String pickup,
    required String feature1,
    required String feature2,
    required String feature3,
    required String feature4,
    required String startDate,
    required String endDate,
    required String imageUrl,
  }) async {
    isUploading = true;
    notifyListeners();

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not authenticated");
      }
      String uid = currentUser.uid;

      List<String> featureList = [
        if (feature1.isNotEmpty) feature1.trim(),
        if (feature2.isNotEmpty) feature2.trim(),
        if (feature3.isNotEmpty) feature3.trim(),
        if (feature4.isNotEmpty) feature4.trim(),
      ];

      Map<String, dynamic> productData = {
        "sellerId": uid,
        "productName": productName.trim(),
        "product": productName.trim(),
        "category": category,
        "rent": rent.trim(),
        "securityDeposit": security.trim(),
        "description": description.trim(),
        "pickup": pickup.trim(),
        "features": featureList,
        "startDate": startDate.trim(),
        "endDate": endDate.trim(),
        "image": imageUrl,
        "status": "Active",
        "createdAt": FieldValue.serverTimestamp(),
      };

      return await _repository.addProductToFirestore(productData);
    } catch (e) {
      debugPrint("Error publishing product: $e");
      rethrow;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}