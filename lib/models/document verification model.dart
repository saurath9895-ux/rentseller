class DocumentVerificationModel {
  final String? govtIdUrl;
  final String? storeProofUrl;

  DocumentVerificationModel({
    this.govtIdUrl,
    this.storeProofUrl,
  });

  factory DocumentVerificationModel.fromMap(Map<String, dynamic> data) {
    return DocumentVerificationModel(
      govtIdUrl: data["govtIdImage"],
      storeProofUrl: data["storeProofImage"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (govtIdUrl != null) "govtIdImage": govtIdUrl,
      if (storeProofUrl != null) "storeProofImage": storeProofUrl,
    };
  }
}