import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentseller/view/user%20account%20details.dart';

import '../models/booking detail model.dart';
import '../view_model/booking details view model.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;
  final Map<String, dynamic> bookingData;

  const BookingDetailsPage({
    super.key,
    required this.bookingId,
    required this.bookingData,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var details = BookingDetailModel.fromMap(widget.bookingData);

    return ChangeNotifierProvider(
      create: (context) => BookingDetailsViewModel(),
      child: Scaffold(
        backgroundColor: Color(0xffF7F5FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Booking Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: details.status.toLowerCase() == "active" ? Colors.green.shade100
                      : details.status.toLowerCase() == "completed" ? Colors.purple.shade100
                      : details.status.toLowerCase() == "cancelled" ? Colors.red.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Current Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      details.status.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: details.status.toLowerCase() == "active" ? Colors.green.shade800
                            : details.status.toLowerCase() == "completed" ? Colors.purple.shade800
                            : details.status.toLowerCase() == "cancelled" ? Colors.red.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Item Name", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 3),
                    Text(details.productName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Divider(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rental Start", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            SizedBox(height: 3),
                            Text(details.startDate, style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Rental End", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            SizedBox(height: 3),
                            Text(details.endDate, style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 25),
                    Text("Booked On", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 3),
                    Text(details.formattedDate, style: TextStyle(fontWeight: FontWeight.bold)),
                    Divider(height: 25),
                    Text("Razorpay Payment ID", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 3),
                    Text(details.paymentId, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace', color: Colors.deepPurple)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Consumer<BookingDetailsViewModel>(
                builder: (context, bookingVM, child) {
                  return FutureBuilder(
                  future: bookingVM.fetchUserDetails(details.userId),
                  builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
                  );
                  }

                  var user = snapshot.data;
                  String userName = user?["name"] ?? user?["username"] ?? widget.bookingData["customerName"] ?? widget.bookingData["userName"] ?? "Unknown Customer";
                  String userPhone = user?["phone"] ?? user?["contact"] ?? widget.bookingData["phone"] ?? "No Phone";
                  String userEmail = user?["email"] ?? widget.bookingData["email"] ?? "No Email";

                  // Safely fetches the uploaded user profile image from Firestore data
                  String? userProfileImage = user?["profileImage"] ?? user?["profileImageUrl"] ?? user?["image"];

                  // Build data map to pass when navigating
                  Map<String, dynamic> navigationData = user ?? {
                  "name": userName,
                  "email": userEmail,
                  "phone": userPhone,
                  "profileImage": userProfileImage,
                  };

                  return GestureDetector(
                  onTap: () {
                  // Navigate to User Account Details Page on click
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => UserAccountDetailsPage(
                  userId: details.userId,
                  userData: navigationData,
                  ),
                  ),
                  );
                  },
                  child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Customer Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(CupertinoIcons.chevron_right, size: 18, color: Colors.grey),
                  ],
                  ),
                  SizedBox(height: 15),
                  Row(
                  children: [
                  CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.purple.shade100,
                  backgroundImage: (userProfileImage != null && userProfileImage.isNotEmpty)
                  ? NetworkImage(userProfileImage) as ImageProvider
                      : null,
                  child: (userProfileImage == null || userProfileImage.isEmpty)
                  ? Icon(CupertinoIcons.person_alt, color: Colors.deepPurple)
                      : null,
                  ),
                  SizedBox(width: 12),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 2),
                  Text(userPhone, style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                  ),
                  ],
                  ),
                  SizedBox(height: 10),
                  Text("Email: $userEmail", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                  ),
                  ),
                  );
                  },
                  );
                },
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Financial Breakdown", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rent Amount", style: TextStyle(color: Colors.grey.shade700)),
                        Text("₹${details.rent}", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Security Deposit (Refundable)", style: TextStyle(color: Colors.grey.shade700)),
                        Text("₹${details.security}", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Platform Commission (10%)", style: TextStyle(color: Colors.red.shade400)),
                        Text("- ₹${details.commission.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade400)),
                      ],
                    ),
                    Divider(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Payout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("₹${details.sellerEarnings.toStringAsFixed(0)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              if (details.status.toLowerCase() == "active") ...[
                Consumer<BookingDetailsViewModel>(
                  builder: (context, bookingVM, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: bookingVM.isLoading
                            ? null
                            : () => bookingVM.handleMarkAsReturned(context, widget.bookingId, details.security),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: bookingVM.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Mark Item as Returned",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}