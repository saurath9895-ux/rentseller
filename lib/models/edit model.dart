class ProductEditModel {
  final String productName;
  final String category;
  final String rentPrice;
  final String securityDeposit;
  final String pickupLocation;
  final String description;
  final String startDate;
  final String endDate;
  final String productImageUrl;
  final List<String> features;

  ProductEditModel({
    required this.productName,
    required this.category,
    required this.rentPrice,
    required this.securityDeposit,
    required this.pickupLocation,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.productImageUrl,
    required this.features,
  });

  factory ProductEditModel.fromMap(Map<String, dynamic> map) {
    return ProductEditModel(
      productName: map["productName"] ?? map["product"] ?? "",
      category: map["category"] ?? "",
      rentPrice: map["rent"] ?? "",
      securityDeposit: map["securityDeposit"] ?? map["security"] ?? "",
      pickupLocation: map["pickup"] ?? "",
      description: map["description"] ?? "",
      startDate: map["startDate"] ?? "",
      endDate: map["endDate"] ?? "",
      productImageUrl: map["image"] ?? map["imageUrl"] ?? "",
      features: List<String>.from(map["features"] ?? [
        map["feature1"] ?? "",
        map["feature2"] ?? "",
        map["feature3"] ?? "",
        map["feature4"] ?? "",
      ].where((f) => f.isNotEmpty)),
    );
  }
}