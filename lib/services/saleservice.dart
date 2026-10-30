import 'package:cloud_firestore/cloud_firestore.dart';

class SellerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Mark Product as Returned & Refund/Credit Security Deposit & Rent
  Future<String?> markProductAsReturned({
    required String bookingId,
    required String sellerId,
    required double rentAmount,
    required double securityDeposit,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference bookingRef = _firestore.collection("bookings").doc(bookingId);
        DocumentReference sellerRef = _firestore.collection("sellers").doc(sellerId);

        // Update booking status
        transaction.update(bookingRef, {
          "status": "Returned",
          "securityRefundStatus": "Refunded",
        });

        // Fetch seller details
        DocumentSnapshot sellerSnap = await transaction.get(sellerRef);
        double currentRevenue = 0.0;
        double currentBalance = 0.0;

        if (sellerSnap.exists) {
          final data = sellerSnap.data() as Map<String, dynamic>?;
          currentRevenue = (data?["totalRevenue"] ?? 0.0).toDouble();
          currentBalance = (data?["availableBalance"] ?? 0.0).toDouble();
        }

        // Add only the rent amount to seller earnings. Security deposit is returned to user.
        transaction.set(sellerRef, {
          "totalRevenue": currentRevenue + rentAmount,
          "availableBalance": currentBalance + rentAmount,
        }, SetOptions(merge: true));
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 2. Handle User Booking Cancellation
  Future<String?> cancelBooking({
    required String bookingId,
    required String sellerId,
    required double totalPaidAmount,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference bookingRef = _firestore.collection("bookings").doc(bookingId);
        DocumentReference sellerRef = _firestore.collection("sellers").doc(sellerId);

        transaction.update(bookingRef, {"status": "Cancelled"});

        DocumentSnapshot sellerSnap = await transaction.get(sellerRef);
        if (sellerSnap.exists) {
          double currentBalance = (sellerSnap.get("availableBalance") ?? 0.0).toDouble();
          // Pull back funds if previously credited
          transaction.update(sellerRef, {
            "availableBalance": currentBalance >= totalPaidAmount ? currentBalance - totalPaidAmount : 0.0,
          });
        }
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 3. Seller Withdrawal Request (Decreases available balance)
  Future<bool> requestWithdrawal(String sellerId, double withdrawAmount) async {
    DocumentReference sellerRef = _firestore.collection("sellers").doc(sellerId);

    return await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(sellerRef);
      if (!snapshot.exists) return false;

      double currentBalance = (snapshot.get("availableBalance") ?? 0.0).toDouble();
      double currentWithdrawn = (snapshot.get("withdrawnAmount") ?? 0.0).toDouble();

      if (currentBalance < withdrawAmount) return false; // Insufficient funds

      transaction.update(sellerRef, {
        "availableBalance": currentBalance - withdrawAmount,
        "withdrawnAmount": currentWithdrawn + withdrawAmount,
      });

      // Log withdrawal
      DocumentReference logRef = _firestore.collection("withdrawals").doc();
      transaction.set(logRef, {
        "sellerId": sellerId,
        "amount": withdrawAmount,
        "timestamp": FieldValue.serverTimestamp(),
        "status": "Success",
      });

      return true;
    });
  }
}