import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/user account model.dart';

class UserAccountDetailsPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const UserAccountDetailsPage({
    super.key,
    required this.userId,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserAccountViewModel()..loadUserData(userId, userData),
      child: Consumer<UserAccountViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading || viewModel.userModel == null) {
            return Scaffold(
              backgroundColor: Color(0xffF7F5FF),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(CupertinoIcons.back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  "My Profile & Documents",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              body: Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            );
          }

          var model = viewModel.userModel!;
          bool hasProfileImg = model.profileImage != null && model.profileImage!.isNotEmpty && model.profileImage!.startsWith("http");
          bool hasIdDoc = model.idProofUrl != null && model.idProofUrl!.isNotEmpty && model.idProofUrl!.startsWith("http");

          return Scaffold(
            backgroundColor: Color(0xffF7F5FF),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(CupertinoIcons.back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "My Profile & Documents",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.purple.shade100,
                          backgroundImage: hasProfileImg ? NetworkImage(model.profileImage!) : null,
                          child: !hasProfileImg
                              ? Icon(CupertinoIcons.person_fill, size: 50, color: Colors.deepPurple)
                              : null,
                        ),
                        SizedBox(height: 12),
                        Text(
                          model.name,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          model.email,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: model.status.toLowerCase() == "active" ? Colors.green.shade100 : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            model.status.toUpperCase(),
                            style: TextStyle(
                              color: model.status.toLowerCase() == "active" ? Colors.green.shade800 : Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Personal Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 15),
                        Text("Full Name", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        SizedBox(height: 3),
                        Text(model.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        Divider(height: 25),
                        Text("Email Address", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        SizedBox(height: 3),
                        Text(model.email, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        Divider(height: 25),
                        Text("Phone Number", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        SizedBox(height: 3),
                        Text(model.phone, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Text("Verification Document", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.purple.shade50,
                              child: Icon(CupertinoIcons.doc_text, color: Colors.deepPurple),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Government ID Proof", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text(
                                  hasIdDoc ? "Uploaded & Verified" : "Not Provided",
                                  style: TextStyle(
                                    color: hasIdDoc ? Colors.green : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            image: hasIdDoc
                                ? DecorationImage(
                              image: NetworkImage(model.idProofUrl!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: !hasIdDoc
                              ? Center(
                            child: Text(
                              "No ID Document Uploaded",
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}