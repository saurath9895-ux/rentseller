import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SalesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getSellerSalesStream(String sellerId) {
    if (sellerId.isEmpty) {
      return const Stream.empty();
    }
    return _firestore
        .collection("bookings")
        .where("sellerId", isEqualTo: sellerId)
        .snapshots();
  }

  Future<List<DocumentSnapshot>> getSellerSales(String sellerId) async {
    if (sellerId.isEmpty) {
      return [];
    }
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("bookings")
          .where("sellerId", isEqualTo: sellerId)
          .get();
      return snapshot.docs;
    } catch (e) {
      debugPrint("Error fetching seller sales: $e");
      return [];
    }
  }
}