import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchSellerBookings(String sellerId) {
    if (sellerId.isEmpty) {
      return const Stream.empty();
    }
    return _firestore
        .collection("bookings")
        .where("sellerId", isEqualTo: sellerId)
        .snapshots();
  }

  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    if (userId.isEmpty) return null;
    try {
      var doc = await _firestore.collection("users").doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
    return null;
  }

  Future<void> updateBookingStatusCompleted(String bookingId) async {
    await _firestore.collection("bookings").doc(bookingId).update({
      "status": "Completed",
      "completedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> processProductReturned({
    required String bookingId,
    required String sellerId,
    required double rentAmount,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference bookingRef = _firestore.collection("bookings").doc(bookingId);
      DocumentReference sellerRef = _firestore.collection("sellers").doc(sellerId);

      transaction.update(bookingRef, {
        "status": "Returned",
        "securityRefundStatus": "Refunded",
      });

      DocumentSnapshot sellerSnap = await transaction.get(sellerRef);
      double currentRevenue = 0.0;
      double currentBalance = 0.0;

      if (sellerSnap.exists) {
        final data = sellerSnap.data() as Map<String, dynamic>?;
        currentRevenue = (data?["totalRevenue"] ?? 0.0).toDouble();
        currentBalance = (data?["availableBalance"] ?? 0.0).toDouble();
      }

      transaction.set(sellerRef, {
        "totalRevenue": currentRevenue + rentAmount,
        "availableBalance": currentBalance + rentAmount,
      }, SetOptions(merge: true));
    });
  }

  Future<void> processCancelBooking({
    required String bookingId,
    required String sellerId,
    required double totalPaidAmount,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference bookingRef = _firestore.collection("bookings").doc(bookingId);
      DocumentReference sellerRef = _firestore.collection("sellers").doc(sellerId);

      transaction.update(bookingRef, {"status": "Cancelled"});

      DocumentSnapshot sellerSnap = await transaction.get(sellerRef);
      if (sellerSnap.exists) {
        double currentBalance = (sellerSnap.get("availableBalance") ?? 0.0).toDouble();
        transaction.update(sellerRef, {
          "availableBalance": currentBalance >= totalPaidAmount ? currentBalance - totalPaidAmount : 0.0,
        });
      }
    });
  }

  Future<bool> processWithdrawal({
    required String sellerId,
    required double withdrawAmount,
  }) async {
    DocumentReference sellerRef = _firestore.collection("sellers").doc(sellerId);

    bool success = await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(sellerRef);
      if (!snapshot.exists) return false;

      double currentBalance = (snapshot.get("availableBalance") ?? 0.0).toDouble();
      double currentWithdrawn = (snapshot.get("withdrawnAmount") ?? 0.0).toDouble();

      if (currentBalance < withdrawAmount) return false;

      transaction.update(sellerRef, {
        "availableBalance": currentBalance - withdrawAmount,
        "withdrawnAmount": currentWithdrawn + withdrawAmount,
      });

      DocumentReference logRef = _firestore.collection("withdrawals").doc();
      transaction.set(logRef, {
        "sellerId": sellerId,
        "amount": withdrawAmount,
        "timestamp": FieldValue.serverTimestamp(),
        "status": "Success",
      });

      return true;
    });

    return success;
  }
}