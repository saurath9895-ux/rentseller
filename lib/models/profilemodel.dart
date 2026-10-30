class ProfileModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String? profileImage;
  final String? govtIdImage;
  final String? storeProofImage;
  final String kycStatus;
  final double availableBalance;
  final double totalRevenue;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    this.profileImage,
    this.govtIdImage,
    this.storeProofImage,
    required this.kycStatus,
    required this.availableBalance,
    required this.totalRevenue,
  });

  factory ProfileModel.fromMap(String uid, Map<String, dynamic> map) {
    return ProfileModel(
      uid: uid,
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      phone: map["phone"] ?? "",
      location: map["location"] ?? "",
      profileImage: map["profileImage"] ?? map["profileImageUrl"],
      govtIdImage: map["govtIdImage"],
      storeProofImage: map["storeProofImage"],
      kycStatus: map["kycStatus"] ?? "Not Verified",
      availableBalance: (map["availableBalance"] ?? 0.0).toDouble(),
      totalRevenue: (map["totalRevenue"] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "location": location,
      if (profileImage != null) "profileImage": profileImage,
      if (govtIdImage != null) "govtIdImage": govtIdImage,
      if (storeProofImage != null) "storeProofImage": storeProofImage,
      "kycStatus": kycStatus,
      "availableBalance": availableBalance,
      "totalRevenue": totalRevenue,
    };
  }
}