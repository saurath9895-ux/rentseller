import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../repository/productdetailrepository.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductDetailRepository _repository = ProductDetailRepository();
  bool isLoading = false;

  Stream<DocumentSnapshot> streamProduct(String productId) {
    return _repository.getProductStream(productId);
  }

  Future<Map<String, dynamic>?> fetchProduct(String productId) async {
    isLoading = true;
    notifyListeners();
    try {
      return await _repository.getProductData(productId);
    } catch (e) {
      debugPrint("Error fetching product detail: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}