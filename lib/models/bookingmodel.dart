import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String productName;
  final String startDate;
  final String endDate;
  final String status;
  final String customerName;
  final String? productImage;
  final int rent;
  final int security;
  final Timestamp? createdAt;

  BookingModel({
    required this.id,
    required this.productName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.customerName,
    this.productImage,
    required this.rent,
    required this.security,
    this.createdAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    int parsedRent = int.tryParse(map["rent"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
    int parsedSecurity = int.tryParse(map["security"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;

    return BookingModel(
      id: id,
      productName: map["productName"] ?? "Unknown Item",
      startDate: map["startDate"] ?? "",
      endDate: map["endDate"] ?? "",
      status: map["status"] ?? "Pending",
      customerName: map["userName"] ?? map["customerName"] ?? "Customer",
      productImage: map["productImage"] ?? map["image"],
      rent: parsedRent,
      security: parsedSecurity,
      createdAt: map["createdAt"] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "productName": productName,
      "startDate": startDate,
      "endDate": endDate,
      "status": status,
      "customerName": customerName,
      "productImage": productImage,
      "rent": rent,
      "security": security,
      "createdAt": createdAt,
    };
  }
}