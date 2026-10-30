class StoreModel {
  final String storeTime;
  final String shopName;
  final String ownerName;
  final String contactPhone;
  final String supportEmail;
  final String locationAddress;

  StoreModel({
    required this.storeTime,
    required this.shopName,
    required this.ownerName,
    required this.contactPhone,
    required this.supportEmail,
    required this.locationAddress,
  });

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      storeTime: map["storeTime"] ?? "",
      shopName: map["shopName"] ?? "",
      ownerName: map["ownerName"] ?? "",
      contactPhone: map["contactPhone"] ?? "",
      supportEmail: map["supportEmail"] ?? "",
      locationAddress: map["locationAddress"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "storeTime": storeTime,
      "shopName": shopName,
      "ownerName": ownerName,
      "contactPhone": contactPhone,
      "supportEmail": supportEmail,
      "locationAddress": locationAddress,
    };
  }

  StoreModel copyWith({
    String? storeTime,
    String? shopName,
    String? ownerName,
    String? contactPhone,
    String? supportEmail,
    String? locationAddress,
  }) {
    return StoreModel(
      storeTime: storeTime ?? this.storeTime,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      contactPhone: contactPhone ?? this.contactPhone,
      supportEmail: supportEmail ?? this.supportEmail,
      locationAddress: locationAddress ?? this.locationAddress,
    );
  }
}