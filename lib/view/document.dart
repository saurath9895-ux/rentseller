import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/document view model.dart';
import '../view_model/profile.dart';

class DocumentVerification extends StatefulWidget {
  const DocumentVerification({super.key});

  @override
  State<DocumentVerification> createState() => _DocumentVerificationState();
}

class _DocumentVerificationState extends State<DocumentVerification> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DocumentVerificationViewModel>(context, listen: false).fetchExistingDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    var docVM = Provider.of<DocumentVerificationViewModel>(context);

    return Consumer<ProfileViewModel>(
      builder: (context, profileVM, child) {
        return Scaffold(
          backgroundColor: Color(0xffF7F5FF),
          body: docVM.isLoadingData
              ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
              : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(CupertinoIcons.back, color: Colors.deepPurple),
                        ),
                      ),
                      Text("Verification", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.deepPurple.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.shield, color: Colors.deepPurple, size: 30),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Why do we need this?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                              SizedBox(height: 4),
                              Text("We verify sellers to ensure trust and safety for all renters on the platform.", style: TextStyle(fontSize: 12, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  child: Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Government ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: docVM.govtIdUrl != null ? Colors.green.shade50 : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                docVM.govtIdUrl != null ? "Uploaded" : "Required",
                                style: TextStyle(
                                  color: docVM.govtIdUrl != null ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text("Govt issued ID", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: docVM.isUploadingGovtId
                              ? null
                              : () async {
                            bool success = await docVM.pickAndUploadDocument(
                              folderName: 'documents',
                              firestoreField: 'govtIdImage',
                              isGovtId: true,
                            );
                            if (!context.mounted) return;
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Document uploaded successfully"), backgroundColor: Colors.green),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Upload failed"), backgroundColor: Colors.red),
                              );
                            }
                          },
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: docVM.govtIdUrl != null ? Colors.green.shade200 : Colors.deepPurple.shade200,
                                width: 2,
                              ),
                              image: docVM.govtIdUrl != null
                                  ? DecorationImage(
                                image: NetworkImage(docVM.govtIdUrl!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: docVM.isUploadingGovtId
                                ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                                : docVM.govtIdUrl == null
                                ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.cloud_upload, color: Colors.deepPurple, size: 35),
                                  SizedBox(height: 8),
                                  Text("Tap to Upload Government ID", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                                ],
                              ),
                            )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  child: Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Store/Address Proof", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: docVM.storeProofUrl != null ? Colors.green.shade50 : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                docVM.storeProofUrl != null ? "Uploaded" : "Required",
                                style: TextStyle(
                                  color: docVM.storeProofUrl != null ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text("Utility bill, Rent agreement, or License", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: docVM.isUploadingStoreProof
                              ? null
                              : () async {
                            bool success = await docVM.pickAndUploadDocument(
                              folderName: 'store_proofs',
                              firestoreField: 'storeProofImage',
                              isGovtId: false,
                            );
                            if (!context.mounted) return;
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Document uploaded successfully"), backgroundColor: Colors.green),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Upload failed"), backgroundColor: Colors.red),
                              );
                            }
                          },
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xffF7F5FF),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: docVM.storeProofUrl != null ? Colors.green.shade200 : Colors.deepPurple.shade200,
                                width: 2,
                              ),
                              image: docVM.storeProofUrl != null
                                  ? DecorationImage(
                                image: NetworkImage(docVM.storeProofUrl!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: docVM.isUploadingStoreProof
                                ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                                : docVM.storeProofUrl == null
                                ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.cloud_upload, color: Colors.deepPurple, size: 35),
                                  SizedBox(height: 8),
                                  Text("Tap to Upload Document", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                                  SizedBox(height: 4),
                                  Text("JPG, PNG or PDF (Max 5MB)", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                ],
                              ),
                            )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: profileVM.isSubmitting
                        ? null
                        : () async {
                      bool success = await profileVM.submitForVerification();

                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Documents submitted for verification"), backgroundColor: Colors.green),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error submitting documents"), backgroundColor: Colors.red),
                        );
                      }
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: profileVM.isSubmitting
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Submit for Verification", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}