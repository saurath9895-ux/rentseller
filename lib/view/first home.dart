import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sellerbooking model.dart';
import '../view_model/color.dart';
import '../view_model/seller view model.dart';
import 'addproduct.dart';
import 'allprod.dart';
import 'bookingdetail.dart';
import 'verification.dart';
import '../view_model/profile.dart';


class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  Future<void> handleAddProductTap(BuildContext context, ProfileViewModel profileVM) async {
    String status = await profileVM.checkSellerVerificationStatus();

    if (!context.mounted) return;

    if (status == "Verified") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
    } else if (status == "Pending") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please wait for Admin to approve your documents."), backgroundColor: Colors.orange),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be Verified to add products."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SellerHomeViewModel(),
      builder: (context, child) {
        var sellerHomeVM = Provider.of<SellerHomeViewModel>(context);

        return Consumer2<ProfileViewModel, SellerHomeViewModel>(
          builder: (context, profileVM, homeVM, child) {
            return Scaffold(
              backgroundColor: Color(0xffF7F5FF),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "RentMe",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Text(
                                  "Seller Panel",
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Hi, Alex 👋",
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "Welcome back!",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.deepPurple.shade50,
                              child: Icon(CupertinoIcons.bell, color: Colors.deepPurple),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.deepPurple,
                                child: Icon(Icons.verified, color: Colors.white),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VerificationBadge(),
                                    SizedBox(height: 4),
                                    Text(
                                      "You can now receive bookings.",
                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(CupertinoIcons.right_chevron, color: Colors.deepPurple, size: 18),
                            ],
                          ),
                        ),
                        SizedBox(height: 22),
                        Text(
                          "Quick Actions",
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.6,
                          ),
                          itemBuilder: (context, index) {
                            List icon = [CupertinoIcons.add_circled_solid, CupertinoIcons.cube_box];
                            List color = [Colors.deepPurple, Colors.green];
                            List title = ["Add Product", "Listings"];

                            return GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  handleAddProductTap(context, profileVM);
                                } else if (index == 1) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Allprod()));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(icon[index], color: color[index], size: 28),
                                    SizedBox(height: 7),
                                    Text(
                                      title[index],
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Bookings",
                              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "See All",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        StreamBuilder<List<SellerHomeBookingModel>>(
                          stream: sellerHomeVM.getRecentBookingsStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    "No recent bookings yet.",
                                    style: TextStyle(color: Colors.grey, fontSize: 15),
                                  ),
                                ),
                              );
                            }

                            var bookings = snapshot.data!;
                            int itemCount = bookings.length > 5 ? 5 : bookings.length;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: itemCount,
                              itemBuilder: (context, index) {
                                var booking = bookings[index];

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookingDetailsPage(
                                            bookingId: booking.id,
                                            bookingData: booking.rawData,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 110,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade200,
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colors.grey.shade200,
                                              image: booking.productImage != null && booking.productImage!.isNotEmpty
                                                  ? DecorationImage(
                                                image: NetworkImage(booking.productImage!),
                                                fit: BoxFit.cover,
                                              )
                                                  : null,
                                            ),
                                            child: booking.productImage == null || booking.productImage!.isEmpty
                                                ? Icon(CupertinoIcons.cube_box, color: Colors.grey)
                                                : null,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        booking.productName,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: BookingColorHelper.getStatusBg(booking.status),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Text(
                                                        booking.status,
                                                        style: TextStyle(
                                                          color: BookingColorHelper.getStatusText(booking.status),
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(Icons.calendar_month, color: Colors.grey, size: 14),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "${booking.startDate} to ${booking.endDate}",
                                                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 6),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "₹${booking.total}",
                                                      style: TextStyle(
                                                        color: Colors.deepPurple,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Icon(CupertinoIcons.right_chevron, size: 16, color: Colors.grey),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}