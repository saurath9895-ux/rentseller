import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/productdetailservice.dart';

class ProductDetailRepository {
  final ProductDetailService _service = ProductDetailService();

  Stream<DocumentSnapshot> getProductStream(String productId) {
    return _service.streamProductDetail(productId);
  }

  Future<Map<String, dynamic>?> getProductData(String productId) async {
    return await _service.fetchProductDetailDoc(productId);
  }
}