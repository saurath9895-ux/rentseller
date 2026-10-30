import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/bookingservice.dart';

class BookingRepository {
  final BookingService _bookingService = BookingService();

  Stream<QuerySnapshot> fetchBookingsStream(String currentUserId) {
    return _bookingService.fetchSellerBookings(currentUserId);
  }

  Stream<QuerySnapshot> getSellerBookings(String sellerId) {
    return _bookingService.fetchSellerBookings(sellerId);
  }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    return await _bookingService.fetchUserDetails(userId);
  }

  Future<void> markBookingCompleted(String bookingId) async {
    await _bookingService.updateBookingStatusCompleted(bookingId);
  }

  Future<void> markProductAsReturned({
    required String bookingId,
    required String sellerId,
    required double rentAmount,
    required double securityDeposit,
  }) async {
    await _bookingService.processProductReturned(
      bookingId: bookingId,
      sellerId: sellerId,
      rentAmount: rentAmount,
    );
  }

  Future<void> cancelBooking({
    required String bookingId,
    required String sellerId,
    required double totalPaidAmount,
  }) async {
    await _bookingService.processCancelBooking(
      bookingId: bookingId,
      sellerId: sellerId,
      totalPaidAmount: totalPaidAmount,
    );
  }

  Future<bool> requestWithdrawal(String sellerId, double withdrawAmount) async {
    return await _bookingService.processWithdrawal(
      sellerId: sellerId,
      withdrawAmount: withdrawAmount,
    );
  }
}