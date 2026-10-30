class ProductDetailModel {
  final String id;
  final String productName;
  final String category;
  final String rentPrice;
  final String securityDeposit;
  final String description;
  final String pickupLocation;
  final String productImageUrl;
  final List<String> features;
  final String startDate;
  final String endDate;
  final String status;

  ProductDetailModel({
    required this.id,
    required this.productName,
    required this.category,
    required this.rentPrice,
    required this.securityDeposit,
    required this.description,
    required this.pickupLocation,
    required this.productImageUrl,
    required this.features,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory ProductDetailModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailModel(
      id: map["id"] ?? "",
      productName: map["productName"] ?? map["product"] ?? "",
      category: map["category"] ?? "",
      rentPrice: map["rent"]?.toString() ?? map["rentPrice"]?.toString() ?? "",
      securityDeposit: map["securityDeposit"]?.toString() ?? map["security"]?.toString() ?? "",
      description: map["description"] ?? "",
      pickupLocation: map["pickup"] ?? map["pickupLocation"] ?? "",
      productImageUrl: map["image"] ?? map["imageUrl"] ?? "",
      features: List<String>.from(map["features"] ?? [
        map["feature1"] ?? "",
        map["feature2"] ?? "",
        map["feature3"] ?? "",
        map["feature4"] ?? "",
      ].where((f) => f != null && f.toString().trim().isNotEmpty)),
      startDate: map["startDate"] ?? "",
      endDate: map["endDate"] ?? "",
      status: map["status"] ?? "Active",
    );
  }
}