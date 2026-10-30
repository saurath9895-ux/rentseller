import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/edit model.dart';
import '../repository/edit repository.dart';

class ProductEditViewModel extends ChangeNotifier {
  final ProductEditRepository _repository = ProductEditRepository();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "default_user";

  bool isLoading = false;
  bool isUploading = false;
  String? productImageUrl;

  final TextEditingController productName = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController rentPrice = TextEditingController();
  final TextEditingController securityDeposit = TextEditingController();
  final TextEditingController pickupLocation = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController feature1 = TextEditingController();
  final TextEditingController feature2 = TextEditingController();
  final TextEditingController feature3 = TextEditingController();
  final TextEditingController feature4 = TextEditingController();

  void populateFields(Map<String, dynamic> snap) {
    var model = ProductEditModel.fromMap(snap);
    productName.text = model.productName;
    category.text = model.category;
    rentPrice.text = model.rentPrice;
    securityDeposit.text = model.securityDeposit;
    pickupLocation.text = model.pickupLocation;
    description.text = model.description;
    startDate.text = model.startDate;
    endDate.text = model.endDate;
    productImageUrl = model.productImageUrl;

    if (model.features.isNotEmpty) {
      feature1.text = model.features.isNotEmpty ? model.features[0] : "";
      feature2.text = model.features.length > 1 ? model.features[1] : "";
      feature3.text = model.features.length > 2 ? model.features[2] : "";
      feature4.text = model.features.length > 3 ? model.features[3] : "";
    }
    notifyListeners();
  }

  Future<bool> updateProductImage(String productId) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return false;

    isUploading = true;
    notifyListeners();

    try {
      dynamic payload = kIsWeb ? await pickedFile.readAsBytes() : File(pickedFile.path);
      String? downloadUrl = await _repository.uploadNewImage(currentUserId, payload);

      if (downloadUrl == null) return false;

      productImageUrl = downloadUrl;
      await _repository.updateProductFields(productId, {"image": downloadUrl});
      return true;
    } catch (e) {
      return false;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<bool> saveChanges(String productId) async {
    isUploading = true;
    notifyListeners();

    try {
      List<String> featureList = [
        if (feature1.text.isNotEmpty) feature1.text.trim(),
        if (feature2.text.isNotEmpty) feature2.text.trim(),
        if (feature3.text.isNotEmpty) feature3.text.trim(),
        if (feature4.text.isNotEmpty) feature4.text.trim(),
      ];

      Map<String, dynamic> updatedData = {
        "product": productName.text.trim(),
        "productName": productName.text.trim(),
        "category": category.text.trim(),
        "rent": rentPrice.text.trim(),
        "securityDeposit": securityDeposit.text.trim(),
        "pickup": pickupLocation.text.trim(),
        "description": description.text.trim(),
        "features": featureList,
        "startDate": startDate.text.trim(),
        "endDate": endDate.text.trim(),
        if (productImageUrl != null) "image": productImageUrl!,
      };

      await _repository.updateProductFields(productId, updatedData);
      return true;
    } catch (e) {
      return false;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}