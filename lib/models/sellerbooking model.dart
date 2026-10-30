import 'package:cloud_firestore/cloud_firestore.dart';

class SellerHomeBookingModel {
  final String id;
  final String productName;
  final String startDate;
  final String endDate;
  final String status;
  final String? productImage;
  final int rent;
  final int security;
  final int total;
  final Timestamp? createdAt;
  final Map<String, dynamic> rawData;

  SellerHomeBookingModel({
    required this.id,
    required this.productName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.productImage,
    required this.rent,
    required this.security,
    required this.total,
    this.createdAt,
    required this.rawData,
  });

  factory SellerHomeBookingModel.fromDoc(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    String productName = data["productName"] ?? "Unknown Item";
    String startDate = data["startDate"] ?? "";
    String endDate = data["endDate"] ?? "";
    String status = data["status"] ?? "Pending";
    String? productImage = data["productImage"] ?? data["image"];

    int rent = int.tryParse(data["rent"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
    int security = int.tryParse(data["security"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
    int total = rent + security;

    Timestamp? createdAt = data["createdAt"] as Timestamp?;

    return SellerHomeBookingModel(
      id: doc.id,
      productName: productName,
      startDate: startDate,
      endDate: endDate,
      status: status,
      productImage: productImage,
      rent: rent,
      security: security,
      total: total,
      createdAt: createdAt,
      rawData: data,
    );
  }
}