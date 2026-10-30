import '../repository/profile repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool isSaving = false;
  bool isSubmitting = false;

  final ProfileRepository _repository = ProfileRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<String> checkSellerVerificationStatus() async {
    if (currentUser == null) return "Not Verified";

    try {
      var data = await _repository.getSellerProfile(currentUser!.uid);
      if (data != null) {
        return data["kycStatus"] ?? "Not Verified";
      }
    } catch (e) {
      print("Error checking status: $e");
    }
    return "Not Verified";
  }

  Future<Map<String, dynamic>?> fetchProfileData() async {
    if (currentUser == null) return null;

    try {
      return await _repository.getSellerProfile(currentUser!.uid);
    } catch (e) {
      print("Error loading profile: $e");
      return null;
    }
  }

  Future<bool> saveProfileData({
    required String name,
    required String email,
    required String phone,
    required String location,
  }) async {
    if (currentUser == null) return false;

    isSaving = true;
    notifyListeners();

    try {
      await _repository.saveProfile(currentUser!.uid, {
        "name": name,
        "email": email,
        "phone": phone,
        "location": location,
      });

      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSaving = false;
      notifyListeners();
      print("Error saving profile: $e");
      return false;
    }
  }

  Future<bool> submitForVerification() async {
    if (currentUser == null) return false;

    isSubmitting = true;
    notifyListeners();

    try {
      await _repository.saveProfile(currentUser!.uid, {
        "kycStatus": "Pending",
      });

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      notifyListeners();
      print("Error submitting documents: $e");
      return false;
    }
  }

  Stream<DocumentSnapshot> getSellerVerificationStream(String userId) {
    return _repository.getSellerStream(userId);
  }
}