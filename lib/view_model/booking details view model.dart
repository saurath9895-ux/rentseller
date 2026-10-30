import 'package:flutter/material.dart';

import '../repository/bookingrepository.dart';

class BookingDetailsViewModel extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    return await _repository.getUserDetails(userId);
  }

  Future<bool> markBookingAsCompleted(String bookingId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.markBookingCompleted(bookingId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> handleMarkAsReturned(BuildContext context, String bookingId, int securityAmount) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Complete Booking?"),
        content: Text("Have you inspected the item and confirmed it's returned safely?\n\nRemember to trigger the ₹$securityAmount security deposit refund from your Razorpay dashboard."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes, Complete", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ) ??
        false;

    if (confirm) {
      bool success = await markBookingAsCompleted(bookingId);

      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking marked as Completed!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating status"), backgroundColor: Colors.red),
        );
      }
    }
  }
}