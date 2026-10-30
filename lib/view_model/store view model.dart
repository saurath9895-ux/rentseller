import 'package:flutter/material.dart';
import '../models/storemodel.dart';
import '../repository/store repositoryy.dart';


class StoreViewModel extends ChangeNotifier {
  final StoreRepository _repository = StoreRepository();

  bool isLoading = true;
  bool isSaving = false;

  final TextEditingController time = TextEditingController();
  final TextEditingController shopName = TextEditingController();
  final TextEditingController ownerName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController supportEmail = TextEditingController();
  final TextEditingController locationAddress = TextEditingController();

  Future<void> loadStoreData() async {
    isLoading = true;
    notifyListeners();

    try {
      var snap = await _repository.fetchStoreDoc();
      if (snap != null) {
        var model = StoreModel.fromMap(snap);
        time.text = model.storeTime;
        shopName.text = model.shopName;
        ownerName.text = model.ownerName;
        contactPhone.text = model.contactPhone;
        supportEmail.text = model.supportEmail;
        locationAddress.text = model.locationAddress;
      }
    } catch (e) {
      debugPrint("Error loading store data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveStoreData() async {
    isSaving = true;
    notifyListeners();

    StoreModel model = StoreModel(
      storeTime: time.text.trim(),
      shopName: shopName.text.trim(),
      ownerName: ownerName.text.trim(),
      contactPhone: contactPhone.text.trim(),
      supportEmail: supportEmail.text.trim(),
      locationAddress: locationAddress.text.trim(),
    );

    bool success = await _repository.updateStoreData(model.toMap());

    isSaving = false;
    notifyListeners();
    return success;
  }
}