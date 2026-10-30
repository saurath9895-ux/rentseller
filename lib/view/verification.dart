import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/profile.dart';

class VerificationBadge extends StatelessWidget {
  const VerificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return const SizedBox();

    return Consumer<ProfileViewModel>(
      builder: (context, profileVM, child) {
        return StreamBuilder<DocumentSnapshot>(
          stream: profileVM.getSellerVerificationStream(user.uid),
          builder: (context, snapshot) {
            String status = "Not Verified";
            Color badgeColor = Colors.grey;

            if (snapshot.hasData && snapshot.data!.exists) {
              var data = snapshot.data!.data() as Map<String, dynamic>?;
              status = data?["kycStatus"] ?? "Not Verified";
            }

            if (status == "Verified") {
              badgeColor = Colors.green;
            } else if (status == "Pending") {
              badgeColor = Colors.orange;
            } else if (status == "Rejected") {
              badgeColor = Colors.red;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: badgeColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    status == "Verified" ? Icons.verified : Icons.info_outline,
                    color: badgeColor,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    status,
                    style: TextStyle(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}