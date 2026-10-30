import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import '../models/document verification model.dart';
import '../repository/document repository.dart';

class DocumentVerificationViewModel extends ChangeNotifier {
  final DocumentVerificationRepository _repository = DocumentVerificationRepository();
  final String currentUid = firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? "";

  bool isLoadingData = true;
  bool isUploadingGovtId = false;
  bool isUploadingStoreProof = false;

  String? govtIdUrl;
  String? storeProofUrl;

  Future<void> fetchExistingDocuments() async {
    isLoadingData = true;
    notifyListeners();

    try {
      if (currentUid.isNotEmpty) {
        var data = await _repository.fetchSellerDocuments(currentUid);
        if (data != null) {
          var model = DocumentVerificationModel.fromMap(data);
          govtIdUrl = model.govtIdUrl;
          storeProofUrl = model.storeProofUrl;
        }
      }
    } catch (e) {
      debugPrint("Error fetching documents: $e");
    } finally {
      isLoadingData = false;
      notifyListeners();
    }
  }

  Future<bool> pickAndUploadDocument({
    required String folderName,
    required String firestoreField,
    required bool isGovtId,
  }) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return false;

    if (isGovtId) {
      isUploadingGovtId = true;
    } else {
      isUploadingStoreProof = true;
    }
    notifyListeners();

    try {
      if (currentUid.isEmpty) return false;

      String? publicUrl = await _repository.uploadFileToStorage(
        uid: currentUid,
        folderName: folderName,
        pickedFile: pickedFile,
        isWeb: kIsWeb,
      );

      if (publicUrl == null) return false;

      await _repository.updateSellerDocumentField(currentUid, firestoreField, publicUrl);

      if (isGovtId) {
        govtIdUrl = publicUrl;
      } else {
        storeProofUrl = publicUrl;
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      if (isGovtId) {
        isUploadingGovtId = false;
      } else {
        isUploadingStoreProof = false;
      }
      notifyListeners();
    }
  }
}