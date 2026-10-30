import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class WalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUid = firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<bool> saveWithdrawalRecord(double amount, String paymentId) async {
    try {
      if (currentUid.isEmpty) return false;

      await _firestore.collection("sellers").doc(currentUid).collection("withdrawals").add({
        "withdrawAmount": amount,
        "paymentId": paymentId,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}