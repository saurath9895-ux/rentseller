import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/salesviewmodel.dart';
import 'withdraw.dart';

class SellerSalesPage extends StatefulWidget {
  const SellerSalesPage({super.key});

  @override
  State<SellerSalesPage> createState() => _SellerSalesPageState();
}

class _SellerSalesPageState extends State<SellerSalesPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesViewModel>(
      builder: (context, salesVM, child) {
        return Scaffold(
          backgroundColor: const Color(0xffF7F5FF),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              "My Sales & Revenue",
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: salesVM.getSellerSalesStream(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No sales records found yet.", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Withdraw()),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                        child: const Text("Go to Withdraw", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }

              var docs = snapshot.data!.docs;

              double totalRevenue = 0;
              double totalCommission = 0;
              double netEarnings = 0;

              for (var doc in docs) {
                var data = doc.data() as Map<String, dynamic>;
                String status = data["status"] ?? "";

                if (status == "Completed" || status == "Active") {
                  int rent = int.tryParse(data["rent"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
                  double commission = rent * 0.10;
                  double sellerPayout = rent - commission;

                  totalRevenue += rent;
                  totalCommission += commission;
                  netEarnings += sellerPayout;
                }
              }

              return ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Net Earnings", style: TextStyle(color: Colors.white70, fontSize: 14)),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Withdraw()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text("Withdraw", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "₹${netEarnings.toStringAsFixed(0)}",
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.white24, height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Gross Rent: ₹${totalRevenue.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            Text("Platform Fee (10%): -₹${totalCommission.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Transaction Breakdown", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      String productName = data["productName"] ?? "Item";
                      String status = data["status"] ?? "Pending";
                      int rent = int.tryParse(data["rent"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "0") ?? 0;
                      double payout = rent * 0.90;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Status: $status"),
                          trailing: Text(
                            "+₹${payout.toStringAsFixed(0)}",
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}