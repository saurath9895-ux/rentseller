class SaleModel {
  final String itemName;
  final String saleDate;
  final String saleAmount;
  final String image;

  SaleModel({
    required this.itemName,
    required this.saleDate,
    required this.saleAmount,
    required this.image,
  });

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      itemName: map["itemName"] ?? "",
      saleDate: map["saleDate"] ?? "",
      saleAmount: map["saleAmount"] ?? "",
      image: map["image"] ?? "",
    );
  }
}