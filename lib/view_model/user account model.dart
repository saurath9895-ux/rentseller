import 'package:flutter/material.dart';
import '../models/user account model.dart';
import '../repository/user account repository.dart';

class UserAccountViewModel extends ChangeNotifier {
  final UserAccountRepository _repository = UserAccountRepository();

  bool isLoading = false;
  UserAccountModel? userModel;

  Future<void> loadUserData(String userId, Map<String, dynamic> fallbackData) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic>? fetchedData = await _repository.getUserData(userId);

    // Fall back to passed map if remote fetch fails or returns empty
    Map<String, dynamic> finalData = fetchedData ?? fallbackData;
    userModel = UserAccountModel.fromMap(finalData);

    isLoading = false;
    notifyListeners();
  }
}