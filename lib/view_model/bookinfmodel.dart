import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../repository/bookingrepository.dart';

class BookingViewModel extends ChangeNotifier {
  bool isUpdating = false;
  bool get isLoading => isUpdating;

  final BookingRepository _repository = BookingRepository();

  Stream<QuerySnapshot> getSellerBookingsStream(String sellerId) {
    return _repository.getSellerBookings(sellerId);
  }

  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    return await _repository.getUserDetails(userId);
  }

  Future<bool> markBookingCompleted(String bookingId) async {
    return await markBookingAsCompleted(bookingId);
  }

  Future<bool> markBookingAsCompleted(String bookingId) async {
    isUpdating = true;
    notifyListeners();

    try {
      await _repository.markBookingCompleted(bookingId);
      isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      isUpdating = false;
      notifyListeners();
      print("Error updating booking status: $e");
      return false;
    }
  }

  Future<String?> markProductAsReturned({
    required String bookingId,
    required String sellerId,
    required double rentAmount,
    required double securityDeposit,
  }) async {
    isUpdating = true;
    notifyListeners();

    try {
      await _repository.markProductAsReturned(
        bookingId: bookingId,
        sellerId: sellerId,
        rentAmount: rentAmount,
        securityDeposit: securityDeposit,
      );

      isUpdating = false;
      notifyListeners();
      return null;
    } catch (e) {
      isUpdating = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> cancelBooking({
    required String bookingId,
    required String sellerId,
    required double totalPaidAmount,
  }) async {
    isUpdating = true;
    notifyListeners();

    try {
      await _repository.cancelBooking(
        bookingId: bookingId,
        sellerId: sellerId,
        totalPaidAmount: totalPaidAmount,
      );

      isUpdating = false;
      notifyListeners();
      return null;
    } catch (e) {
      isUpdating = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<bool> requestWithdrawal(String sellerId, double withdrawAmount) async {
    isUpdating = true;
    notifyListeners();

    try {
      bool success = await _repository.requestWithdrawal(sellerId, withdrawAmount);
      isUpdating = false;
      notifyListeners();
      return success;
    } catch (e) {
      isUpdating = false;
      notifyListeners();
      print("Error requesting withdrawal: $e");
      return false;
    }
  }
}