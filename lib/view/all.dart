import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/bookinfmodel.dart';
import 'bookingdetail.dart';

class All extends StatefulWidget {
  final String statusFilter;

  const All({super.key, required this.statusFilter});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  Color getStatusBg(String status) {
    String lowerStatus = status.trim().toLowerCase();
    if (lowerStatus == "pending") return Colors.orangeAccent.shade100;
    if (lowerStatus == "active" || lowerStatus == "upcoming") return Colors.greenAccent.shade100;
    if (lowerStatus == "completed") return Colors.purple.shade100;
    if (lowerStatus == "cancelled") return Colors.redAccent.shade100;
    return Colors.blueAccent.shade100;
  }

  Color getStatusText(String status) {
    String lowerStatus = status.trim().toLowerCase();
    if (lowerStatus == "pending") return Colors.deepOrange;
    if (lowerStatus == "active" || lowerStatus == "upcoming") return Colors.green.shade800;
    if (lowerStatus == "completed") return Colors.deepPurple;
    if (lowerStatus == "cancelled") return Colors.red.shade800;
    return Colors.blue.shade900;
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection("bookings")
        .where("sellerId", isEqualTo: currentUserId);

    return Consumer<BookingViewModel>(
      builder: (context, bookingVM, child) {
        return Scaffold(
          backgroundColor: const Color(0xffF7F5FF),
          body: StreamBuilder(
            stream: query.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No bookings found.",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              var allDocs = snapshot.data!.docs;
              var docs = allDocs.where((doc) {
                var data = doc.data() as Map<String, dynamic>;
                String status = (data["status"] ?? "").toString().trim().toLowerCase();
                String filter = widget.statusFilter.trim().toLowerCase();

                if (filter == "all") return true;
                return status == filter;
              }).toList();

              if (docs.isEmpty) {
                return Center(
                  child: Text(
                    "No ${widget.statusFilter} bookings found.",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              docs.sort((a, b) {
                Timestamp? timeA = (a.data() as Map<String, dynamic>)["createdAt"] as Timestamp?;
                Timestamp? timeB = (b.data() as Map<String, dynamic>)["createdAt"] as Timestamp?;
                if (timeA == null || timeB == null) return 0;
                return timeB.compareTo(timeA);
              });

              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var doc = docs[index];
                  var data = doc.data() as Map<String, dynamic>;

                  String name = data["productName"] ?? "Unknown Item";
                  String startDate = data["startDate"] ?? "";
                  String endDate = data["endDate"] ?? "";
                  String status = data["status"] ?? "Pending";
                  String customerName = data["userName"] ?? data["customerName"] ?? "Customer";

                  String? productImage = data["productImage"] ?? data["image"];

                  int rent = int.tryParse(data["rent"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
                  int security = int.tryParse(data["security"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
                  int total = rent + security;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsPage(
                            bookingId: doc.id,
                            bookingData: data,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 85,
                                width: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey.shade200,
                                  image: productImage != null && productImage.isNotEmpty
                                      ? DecorationImage(
                                    image: NetworkImage(productImage),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: productImage == null || productImage.isEmpty
                                    ? const Icon(CupertinoIcons.cube_box, color: Colors.grey)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: getStatusBg(status),
                                          ),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: getStatusText(status),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.person_outline, size: 15, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          customerName,
                                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          "$startDate - $endDate",
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "₹$total",
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (status.toLowerCase() == "active") ...[
                            const SizedBox(height: 10),
                            const Divider(color: Colors.grey),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: bookingVM.isLoading
                                    ? null
                                    : () => _completeBooking(context, doc.id, security, bookingVM),
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                label: const Text("Mark as Returned",
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _completeBooking(
      BuildContext context, String docId, int securityAmount, BookingViewModel bookingVM) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Complete Booking?"),
        content: const Text("Have you received the item back?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Mark Completed", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ) ??
        false;

    if (confirm) {
      bool success = await bookingVM.markBookingAsCompleted(docId);

      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking marked as completed!"), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update booking status."), backgroundColor: Colors.red),
        );
      }
    }
  }
}