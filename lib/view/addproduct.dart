import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../view_model/addproductviewmodel.dart';
import 'detail.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController productName = TextEditingController();
  String? selectedCategory;
  final TextEditingController rentPrice = TextEditingController();
  final TextEditingController securityDeposit = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController pickupLocation = TextEditingController();
  final TextEditingController feature1 = TextEditingController();
  final TextEditingController feature2 = TextEditingController();
  final TextEditingController feature3 = TextEditingController();
  final TextEditingController feature4 = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();

  String? uploadedImageUrl;
  Uint8List? webImageBytes;
  XFile? selectedImageFile;

  @override
  void dispose() {
    productName.dispose();
    rentPrice.dispose();
    securityDeposit.dispose();
    description.dispose();
    pickupLocation.dispose();
    feature1.dispose();
    feature2.dispose();
    feature3.dispose();
    feature4.dispose();
    startDate.dispose();
    endDate.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        String monthName = _getMonthName(picked.month);
        controller.text = "${picked.day} $monthName";
      });
    }
  }

  String _getMonthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductViewModel>(
      builder: (context, productVM, child) {
        return Scaffold(
          backgroundColor: Color(0xffF7F5FF),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(CupertinoIcons.back, color: Colors.deepPurple),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Add New Product",
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Product Photos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: productVM.isUploading
                          ? null
                          : () async {
                        final picker = ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          String uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";
                          dynamic payload = kIsWeb ? await pickedFile.readAsBytes() : File(pickedFile.path);

                          if (kIsWeb) {
                            setState(() {
                              selectedImageFile = pickedFile;
                              webImageBytes = payload as Uint8List;
                            });
                          } else {
                            setState(() {
                              selectedImageFile = pickedFile;
                            });
                          }

                          String? url = await productVM.uploadImageOnly(uid, payload);
                          if (url != null) {
                            setState(() {
                              uploadedImageUrl = url;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Image uploaded successfully!"), backgroundColor: Colors.green),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Image upload failed."), backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.deepPurple.shade100, width: 1.5),
                          image: uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(uploadedImageUrl!),
                            fit: BoxFit.cover,
                          )
                              : selectedImageFile != null && kIsWeb && webImageBytes != null
                              ? DecorationImage(
                            image: MemoryImage(webImageBytes!),
                            fit: BoxFit.cover,
                          )
                              : selectedImageFile != null && !kIsWeb
                              ? DecorationImage(
                            image: FileImage(File(selectedImageFile!.path)),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: productVM.isUploading
                            ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                            : uploadedImageUrl == null && selectedImageFile == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.deepPurple,
                              child: Icon(CupertinoIcons.camera, color: Colors.white, size: 26),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tap to upload the image",
                              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
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
                        Text("Product Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 8),
                        TextField(
                          controller: productName,
                          decoration: InputDecoration(
                            hintText: "Enter product name",
                            filled: true,
                            fillColor: Color(0xffF7F5FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text("Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: InputDecoration(
                            hintText: "Select category",
                            filled: true,
                            fillColor: Color(0xffF7F5FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                          items: ["Electronics", "Vehicles", "Cameras", "Gaming", "Furniture", "Tools"]
                              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                              .toList(),
                          onChanged: (value) => setState(() => selectedCategory = value),
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
                                    controller: rentPrice,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "500",
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
                                    controller: securityDeposit,
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
                        Text("Pickup Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 8),
                        TextField(
                          controller: pickupLocation,
                          decoration: InputDecoration(
                            hintText: "Enter pickup location",
                            filled: true,
                            fillColor: Color(0xffF7F5FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text("Available Dates", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 8),
                        Container(
                          height: 65,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepPurple.shade100),
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xffF7F5FF),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context, startDate),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                    child: Row(
                                      children: [
                                        Icon(CupertinoIcons.calendar, color: Colors.deepPurple, size: 20),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              startDate.text.isEmpty ? "Select Start" : startDate.text,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            Text("Start Date", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Icon(CupertinoIcons.arrow_right, color: Colors.grey, size: 16),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context, endDate),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                    child: Row(
                                      children: [
                                        Icon(CupertinoIcons.calendar, color: Colors.deepPurple, size: 20),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              endDate.text.isEmpty ? "Select End" : endDate.text,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            Text("End Date", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        SizedBox(height: 8),
                        TextField(
                          controller: description,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Write details...",
                            filled: true,
                            fillColor: Color(0xffF7F5FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: productVM.isUploading
                        ? null
                        : () async {
                      if (productName.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a product name"), backgroundColor: Colors.red),
                        );
                        return;
                      }
                      if (uploadedImageUrl == null || uploadedImageUrl!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please wait for the image to finish uploading"), backgroundColor: Colors.red),
                        );
                        return;
                      }

                      try {
                        String? uniqueId = await productVM.publishProduct(
                          productName: productName.text,
                          category: selectedCategory ?? "Other",
                          rent: rentPrice.text,
                          security: securityDeposit.text,
                          description: description.text,
                          pickup: pickupLocation.text,
                          feature1: feature1.text,
                          feature2: feature2.text,
                          feature3: feature3.text,
                          feature4: feature4.text,
                          startDate: startDate.text,
                          endDate: endDate.text,
                          imageUrl: uploadedImageUrl!,
                        );

                        if (!mounted) return;

                        if (uniqueId != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Product Listed Successfully"), backgroundColor: Colors.green),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(productId: uniqueId),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to publish: $e"), backgroundColor: Colors.red),
                        );
                      }
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: productVM.isUploading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Publish Product",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}