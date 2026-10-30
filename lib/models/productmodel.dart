import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String productName;
  final String category;
  final String rent;
  final String securityDeposit;
  final String description;
  final String pickup;
  final String image;
  final List<String> features;
  final String status;

  ProductModel({
    required this.id,
    required this.productName,
    required this.category,
    required this.rent,
    required this.securityDeposit,
    required this.description,
    required this.pickup,
    required this.image,
    required this.features,
    required this.status,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      productName: map["productName"] ?? map["product"] ?? "",
      category: map["category"] ?? "",
      rent: map["rent"] ?? "",
      securityDeposit: map["securityDeposit"] ?? map["security"] ?? "",
      description: map["description"] ?? "",
      pickup: map["pickup"] ?? "",
      image: map["image"] ?? "",
      features: List<String>.from(map["features"] ?? []),
      status: map["status"] ?? "Active",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "productName": productName,
      "product": productName,
      "category": category,
      "rent": rent,
      "securityDeposit": securityDeposit,
      "description": description,
      "pickup": pickup,
      "image": image,
      "features": features,
      "status": status,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }
}