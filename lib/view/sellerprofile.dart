import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthViewModel;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentseller/view/loginview.dart';
import 'document.dart';
import 'editprofile.dart';
import 'helpsupport.dart';
import 'privacy.dart';
import '../view_model/authview.dart';
import 'store.dart';
import 'verification.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({super.key});

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  final List accountTitles = [
    "Edit Profile",
    "Store Details",
    "Documents",
    "Privacy Policy",
    "Support",
  ];

  final List accountIcons = [
    Icons.edit_outlined,
    Icons.storefront_outlined,
    Icons.description_outlined,
    Icons.privacy_tip,
    Icons.headset_mic_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Consumer<AuthViewModel>(
      builder: (context, authVM, child) {
        return Scaffold(
          backgroundColor: const Color(0xffF7F5FF),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const Text(
                    "Manage your seller account",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<DocumentSnapshot>(
                    stream: currentUser != null
                        ? FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).snapshots()
                        : null,
                    builder: (context, snapshot) {
                      String displayName = "Seller User";
                      String displayEmail = currentUser?.email ?? "No Email";
                      String? profileImageUrl;

                      if (snapshot.hasData && snapshot.data!.exists) {
                        var data = snapshot.data!.data() as Map<String, dynamic>;
                        displayName = data["name"] ?? "Seller User";
                        displayEmail = data["email"] ?? currentUser?.email ?? "No Email";
                        profileImageUrl = data["profileImage"];
                      }

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.deepPurple.shade50,
                              backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
                                  ? NetworkImage(profileImageUrl)
                                  : null,
                              child: profileImageUrl == null || profileImageUrl.isEmpty
                                  ? const Icon(
                                Icons.person,
                                size: 34,
                                color: Colors.deepPurple,
                              )
                                  : null,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    displayEmail,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const VerificationBadge(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      height: 400,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: accountTitles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile()));
                                } else if (index == 1) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Store()));
                                } else if (index == 2) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DocumentVerification()));
                                } else if (index == 3) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  Terms(mdFilename: 'terms.md')));
                                } else if (index == 4) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupport()));
                                }
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.deepPurple.shade50,
                                  child: Icon(
                                    accountIcons[index],
                                    color: Colors.deepPurple,
                                    size: 19,
                                  ),
                                ),
                                title: Text(
                                  accountTitles[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                trailing: const Icon(
                                  CupertinoIcons.right_chevron,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Log Out"),
                          content: const Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No", style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await authVM.signOut();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(backgroundColor: Colors.green, content: Text("Signed out successfully")),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginView()),
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Yes", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}