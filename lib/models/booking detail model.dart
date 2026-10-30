import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailModel {
  final String productName;
  final String status;
  final String startDate;
  final String endDate;
  final String paymentId;
  final String userId;
  final int rent;
  final int security;
  final int totalPaid;
  final double commission;
  final double sellerEarnings;
  final String formattedDate;

  BookingDetailModel({
    required this.productName,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.paymentId,
    required this.userId,
    required this.rent,
    required this.security,
    required this.totalPaid,
    required this.commission,
    required this.sellerEarnings,
    required this.formattedDate,
  });

  factory BookingDetailModel.fromMap(Map<String, dynamic> data) {
    String productName = data["productName"] ?? "Unknown Item";
    String status = data["status"] ?? "Pending";
    String startDate = data["startDate"] ?? "N/A";
    String endDate = data["endDate"] ?? "N/A";
    String paymentId = data["paymentId"] ?? "N/A";

    String userId = data["buyerId"] ?? data["userId"] ?? data["customerId"] ?? data["uid"] ?? "";

    int rent = int.tryParse(data["rent"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
    int security = int.tryParse(data["security"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
    int totalPaid = rent + security;

    double commission = rent * 0.10;
    double sellerEarnings = totalPaid - commission;

    String formattedDate = "Just now";
    if (data["createdAt"] != null && data["createdAt"] is Timestamp) {
      DateTime dt = (data["createdAt"] as Timestamp).toDate();
      formattedDate = "${dt.day}/${dt.month}/${dt.year} at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
    }

    return BookingDetailModel(
      productName: productName,
      status: status,
      startDate: startDate,
      endDate: endDate,
      paymentId: paymentId,
      userId: userId,
      rent: rent,
      security: security,
      totalPaid: totalPaid,
      commission: commission,
      sellerEarnings: sellerEarnings,
      formattedDate: formattedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "productName": productName,
      "status": status,
      "startDate": startDate,
      "endDate": endDate,
      "paymentId": paymentId,
      "userId": userId,
      "rent": rent,
      "security": security,
      "totalPaid": totalPaid,
      "commission": commission,
      "sellerEarnings": sellerEarnings,
      "formattedDate": formattedDate,
    };
  }
}