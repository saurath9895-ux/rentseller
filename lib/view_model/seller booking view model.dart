import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/bookingmodel.dart';
import '../repository/bookingrepository.dart';

class SellerBookingViewModel extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<List<BookingModel>> getBookingsByStatusStream(String statusFilter) {
    return _repository.fetchBookingsStream(currentUserId).map((snapshot) {
      var bookings = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return BookingModel.fromMap(data, doc.id);
      }).where((booking) {
        String status = booking.status.trim().toLowerCase();
        String filter = statusFilter.trim().toLowerCase();

        if (filter == "all") return true;
        return status == filter;
      }).toList();

      bookings.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return bookings;
    });
  }

  Future<bool> markBookingAsCompleted(String docId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection("bookings").doc(docId).update({
        "status": "Completed",
      });
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}