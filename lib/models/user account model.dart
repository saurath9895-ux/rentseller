class UserAccountModel {
  final String name;
  final String email;
  final String phone;
  final String status;
  final String? profileImage;
  final String? idProofUrl;

  UserAccountModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    this.profileImage,
    this.idProofUrl,
  });

  factory UserAccountModel.fromMap(Map<String, dynamic> map) {
    return UserAccountModel(
      name: map["name"] ?? map["username"] ?? "Unknown User",
      email: map["email"] ?? "No Email Provided",
      phone: map["phone"] ?? "No Phone Provided",
      status: map["status"] ?? "Active",
      profileImage: map["profileImage"] ?? map["profileImageUrl"] ?? map["image"],
      idProofUrl: map["verificationDocumentUrl"] ?? map["govtIdImage"] ?? map["idProof"] ?? map["documentUrl"],
    );
  }
}