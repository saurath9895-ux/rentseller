import 'package:flutter/material.dart';

class BookingColorHelper {
  static Color getStatusBg(String status) {
    String lower = status.trim().toLowerCase();
    if (lower == "active") return Colors.greenAccent.shade100;
    if (lower == "completed") return Colors.purple.shade100;
    if (lower == "cancelled") return Colors.redAccent.shade100;
    return Colors.orangeAccent.shade100;
  }

  static Color getStatusText(String status) {
    String lower = status.trim().toLowerCase();
    if (lower == "active") return Colors.green.shade800;
    if (lower == "completed") return Colors.deepPurple;
    if (lower == "cancelled") return Colors.red.shade800;
    return Colors.deepOrange;
  }
}