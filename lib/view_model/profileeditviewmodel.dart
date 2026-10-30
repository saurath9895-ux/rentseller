import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import '../models/profilemodel.dart';
import '../repository/profile repository.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();
  final String currentUid = firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? "";

  bool isLoading = true;
  bool isUploadingImage = false;
  String? profileImageUrl;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController location = TextEditingController();

  Future<void> loadProfileData() async {
    isLoading = true;
    notifyListeners();

    try {
      if (currentUid.isNotEmpty) {
        var snap = await _repository.fetchProfileDoc(currentUid);
        if (snap != null) {
          var model = ProfileModel.fromMap(currentUid, snap);
          name.text = model.name;
          email.text = model.email;
          phone.text = model.phone;
          location.text = model.location;
          profileImageUrl = model.profileImage;
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfileImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return false;

    isUploadingImage = true;
    notifyListeners();

    try {
      if (currentUid.isEmpty) return false;

      dynamic imagePayload;
      if (kIsWeb) {
        imagePayload = await pickedFile.readAsBytes();
      } else {
        imagePayload = File(pickedFile.path);
      }

      String? publicUrl = await _repository.uploadImage(
        uid: currentUid,
        pickedFile: imagePayload,
        isWeb: kIsWeb,
      );

      if (publicUrl == null) {
        isUploadingImage = false;
        notifyListeners();
        return false;
      }

      await _repository.updateProfileImageField(currentUid, publicUrl);
      profileImageUrl = publicUrl;

      isUploadingImage = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error updating profile image: $e");
      isUploadingImage = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveChanges() async {
    if (currentUid.isEmpty) return false;

    Map<String, dynamic> data = {
      "name": name.text.trim(),
      "email": email.text.trim(),
      "phone": phone.text.trim(),
      "location": location.text.trim(),
    };

    return await _repository.updateProfileData(currentUid, data);
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    location.dispose();
    super.dispose();
  }
}