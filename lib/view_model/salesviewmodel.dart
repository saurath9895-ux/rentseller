import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../repository/salesrepository.dart';

class SalesViewModel extends ChangeNotifier {
  final SalesRepository _repository = SalesRepository();

  // Mock data lists if used for local UI tabs
  List<String> itemNames = [];
  List<String> saleDates = [];
  List<String> saleAmounts = [];
  List<String> images = [];

  // Expose the stream from repository
  Stream<QuerySnapshot> getSellerSalesStream(String sellerId) {
    return _repository.getSellerSalesStream(sellerId);
  }
}