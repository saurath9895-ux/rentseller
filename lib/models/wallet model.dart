class WalletModel {
  final double withdrawAmount;
  final String paymentId;

  WalletModel({
    required this.withdrawAmount,
    required this.paymentId,
  });

  Map<String, dynamic> toMap() {
    return {
      "withdrawAmount": withdrawAmount,
      "paymentId": paymentId,
      "createdAt": DateTime.now(),
    };
  }
}