import '../services/edit servic.dart';

class ProductEditRepository {
  final ProductEditService _service = ProductEditService();

  Future<String?> uploadNewImage(String uid, dynamic imageInput) async {
    return await _service.uploadImage(uid, imageInput);
  }

  Future<void> updateProductFields(String productId, Map<String, dynamic> data) async {
    await _service.updateFirestoreData(productId, data);
  }
}