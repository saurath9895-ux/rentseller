import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product detail.dart';
import '../view_model/productdetailviewmodel.dart';

class DetailPage extends StatefulWidget {
  final String? productId;
  final String? j;

  DetailPage({super.key, this.productId, this.j});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final List featureIcons = [
    CupertinoIcons.camera,
    CupertinoIcons.video_camera,
    CupertinoIcons.wifi,
    CupertinoIcons.battery_100,
  ];

  @override
  Widget build(BuildContext context) {
    String activeId = widget.productId ?? widget.j ?? "";

    return Consumer<ProductDetailViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder<DocumentSnapshot>(
            stream: viewModel.streamProduct(activeId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text("Product not found"));
              }

              var data = snapshot.data!.data() as Map<String, dynamic>;
              ProductDetailModel product = ProductDetailModel.fromMap(data);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 330,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        color: Colors.purple.shade50,
                        image: product.productImageUrl.isNotEmpty && product.productImageUrl.startsWith("http")
                            ? DecorationImage(
                          image: NetworkImage(product.productImageUrl),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: product.productImageUrl.isEmpty
                          ? Center(
                        child: Icon(CupertinoIcons.photo, size: 60, color: Colors.deepPurple),
                      )
                          : Padding(
                        padding: EdgeInsets.only(bottom: 170.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(CupertinoIcons.back, color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 12.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(CupertinoIcons.heart, color: Colors.deepPurple),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.productName.isNotEmpty ? product.productName : "Product Name",
                                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              ),
                              Icon(CupertinoIcons.share, color: Colors.deepPurple, size: 24),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 18),
                              SizedBox(width: 4),
                              Text("4.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(width: 4),
                              Text("(24 reviews)", style: TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(CupertinoIcons.location_solid, color: Colors.deepPurple, size: 16),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  product.pickupLocation.isNotEmpty ? product.pickupLocation : "Location",
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Container(
                            height: 95,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xffF7F5FF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "₹${product.rentPrice.isNotEmpty ? product.rentPrice : "0"}",
                                        style: TextStyle(color: Colors.deepPurple, fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 2),
                                      Text("Per Day", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Container(height: 45, width: 1.5, color: Colors.purple.shade100),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "₹${product.securityDeposit.isNotEmpty ? product.securityDeposit : "0"}",
                                        style: TextStyle(color: Colors.deepPurple, fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 2),
                                      Text("Security Deposit", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 22),
                          Text("Available Dates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          SizedBox(height: 10),
                          Container(
                            height: 70,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Color(0xffF7F5FF),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.purple.shade100, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.calendar, color: Colors.deepPurple, size: 20),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.startDate.isNotEmpty ? product.startDate : "Start",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                        ),
                                        Text("Start Date", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(CupertinoIcons.arrow_right, color: Colors.grey, size: 18),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.calendar, color: Colors.deepPurple, size: 20),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.endDate.isNotEmpty ? product.endDate : "End",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                        ),
                                        Text("End Date", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 22),
                          Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          SizedBox(height: 8),
                          Text(
                            product.description.isNotEmpty ? product.description : "No description provided.",
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.4),
                          ),
                          SizedBox(height: 22),
                          Text("Features", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: product.features.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Color(0xffF7F5FF),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(featureIcons[index % featureIcons.length], color: Colors.deepPurple, size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        product.features[index],
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}