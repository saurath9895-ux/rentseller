import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/sellerbooking model.dart';
import '../repository/bookingrepository.dart';

class SellerHomeViewModel extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  Stream<List<SellerHomeBookingModel>> getRecentBookingsStream() {
    return _repository.fetchBookingsStream(currentUserId).map((snapshot) {
      var bookings = snapshot.docs.map((doc) {
        return SellerHomeBookingModel.fromDoc(doc);
      }).toList();

      bookings.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return bookings;
    });
  }

  Future<void> handleAddProductTap(BuildContext context, dynamic profileVM) async {
    String status = await profileVM.checkSellerVerificationStatus();

    if (!context.mounted) return;

    if (status == "Verified") {
      // Navigation is delegated to view or handled via callbacks if preferred,
      // but here we check and return status for the view to handle route.
    }
  }
}