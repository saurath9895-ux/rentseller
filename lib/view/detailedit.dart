import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/product edit view model.dart';

class ProductEditPage extends StatefulWidget {
  final String productId;

  ProductEditPage({super.key, required this.productId});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductEditViewModel(),
      child: Consumer<ProductEditViewModel>(
        builder: (context, viewModel, child) {
          if (!isInitialized) {
            FirebaseFirestore.instance.collection('products').doc(widget.productId).get().then((doc) {
              if (doc.exists && doc.data() != null) {
                viewModel.populateFields(doc.data()!);
                setState(() => isInitialized = true);
              }
            });
          }

          return Scaffold(
            backgroundColor: Color(0xffF7F5FF),
            appBar: AppBar(
              title: Text("Edit Product", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(CupertinoIcons.back, color: Colors.deepPurple),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: viewModel.isLoading || !isInitialized
                ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                : SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        bool success = await viewModel.updateProductImage(widget.productId);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Image updated successfully"), backgroundColor: Colors.green),
                          );
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.deepPurple.shade100, width: 1.5),
                          image: viewModel.productImageUrl != null && viewModel.productImageUrl!.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(viewModel.productImageUrl!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: viewModel.isUploading
                            ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                            : viewModel.productImageUrl == null || viewModel.productImageUrl!.isEmpty
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.deepPurple,
                              child: Icon(CupertinoIcons.camera, color: Colors.white, size: 24),
                            ),
                            SizedBox(height: 8),
                            Text("Change Photo", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                          ],
                        )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 8),
                        TextField(
                          controller: viewModel.category,
                          decoration: InputDecoration(
                            hintText: "Enter category",
                            filled: true,
                            fillColor: Color(0xffF7F5FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Rent (₹ / day)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: viewModel.rentPrice,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "700kn",
                                      filled: true,
                                      fillColor: Color(0xffF7F5FF),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Security Deposit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: viewModel.securityDeposit,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "2000",
                                      filled: true,
                                      fillColor: Color(0xffF7F5FF),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: viewModel.startDate,
                                    decoration: InputDecoration(
                                      hintText: "e.g. 24 Sep",
                                      filled: true,
                                      fillColor: Color(0xffF7F5FF),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("End Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: viewModel.endDate,
                                    decoration: InputDecoration(
                                      hintText: "e.g. 26 Sep",
                                      filled: true,
                                      fillColor: Color(0xffF7F5FF),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text("Pickup Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 8),
                        TextField(
                          controller: viewModel.pickupLocation,
                          decoration: InputDecoration(
                            hintText: "Store address or area name",
                            filled: true,
                            fillColor: Color(0xffF7F5FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 8),
                        TextField(
                          controller: viewModel.description,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Write details...",
                            filled: true,
                            fillColor: Color(0xffF7F5FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text("Key Features", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: viewModel.feature1,
                                decoration: InputDecoration(
                                  hintText: "Feature 1",
                                  filled: true,
                                  fillColor: Color(0xffF7F5FF),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: viewModel.feature2,
                                decoration: InputDecoration(
                                  hintText: "Feature 2",
                                  filled: true,
                                  fillColor: Color(0xffF7F5FF),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: viewModel.feature3,
                                decoration: InputDecoration(
                                  hintText: "Feature 3",
                                  filled: true,
                                  fillColor: Color(0xffF7F5FF),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: viewModel.feature4,
                                decoration: InputDecoration(
                                  hintText: "Feature 4",
                                  filled: true,
                                  fillColor: Color(0xffF7F5FF),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: viewModel.isUploading
                          ? null
                          : () async {
                        bool success = await viewModel.saveChanges(widget.productId);
                        if (!mounted) return;
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Changes saved successfully"), backgroundColor: Colors.green),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to save changes"), backgroundColor: Colors.red),
                          );
                        }
                      },
                      child: viewModel.isUploading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}