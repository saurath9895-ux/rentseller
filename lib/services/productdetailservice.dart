import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> streamProductDetail(String productId) {
    if (productId.isEmpty) return Stream.empty();
    return _firestore.collection('products').doc(productId).snapshots();
  }

  Future<Map<String, dynamic>?> fetchProductDetailDoc(String productId) async {
    if (productId.isEmpty) return null;
    var doc = await _firestore.collection('products').doc(productId).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}