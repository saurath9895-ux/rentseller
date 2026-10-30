import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/store view model.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreViewModel>(context, listen: false).loadStoreData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var storeVM = Provider.of<StoreViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: storeVM.isLoading || storeVM.isSaving
          ? Center(child: CircularProgressIndicator())
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
                      child: Icon(CupertinoIcons.back, color: Colors.purple),
                    ),
                  ),
                  Text("Store Details", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  Icon(Icons.check, color: Colors.transparent),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Shop Operational Hours", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextField(
                      controller: storeVM.time,
                      decoration: InputDecoration(
                        hintText: "e.g. 09:00 AM - 08:00 PM",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        prefixIcon: Icon(CupertinoIcons.clock, color: Colors.purple),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Shop Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    SizedBox(height: 8),
                    TextField(
                      controller: storeVM.shopName,
                      decoration: InputDecoration(
                        hintText: "e.g. Alex Rentals",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        prefixIcon: Icon(CupertinoIcons.settings, color: Colors.purple, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text("Owner / Contact Person", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    SizedBox(height: 8),
                    TextField(
                      controller: storeVM.ownerName,
                      decoration: InputDecoration(
                        hintText: "Full name",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        prefixIcon: Icon(CupertinoIcons.person, color: Colors.purple, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text("Contact Phone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    SizedBox(height: 8),
                    TextField(
                      controller: storeVM.contactPhone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Phone number",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        prefixIcon: Icon(CupertinoIcons.phone, color: Colors.purple, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text("Support Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    SizedBox(height: 8),
                    TextField(
                      controller: storeVM.supportEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Business email address",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        prefixIcon: Icon(CupertinoIcons.mail, color: Colors.purple, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text("Store Location Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    SizedBox(height: 8),
                    TextField(
                      controller: storeVM.locationAddress,
                      decoration: InputDecoration(
                        hintText: "Store street, city, state",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        prefixIcon: Icon(Icons.location_on_outlined, color: Colors.purple, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
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
                onTap: () async {
                  bool success = await storeVM.saveStoreData();
                  if (!context.mounted) return;

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Store Information Saved"), backgroundColor: Colors.green),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error saving store data"), backgroundColor: Colors.red),
                    );
                  }
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(15)),
                  child: Center(child: Text("Save Store Information", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}