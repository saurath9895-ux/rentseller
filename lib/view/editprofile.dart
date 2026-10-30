import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/profileeditviewmodel.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileEditViewModel>(context, listen: false).loadProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var profileEditVM = Provider.of<ProfileEditViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: profileEditVM.isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.purple.shade50,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(CupertinoIcons.back, color: Colors.deepPurple),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: EdgeInsets.only(left: 48.0),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: GestureDetector(
                onTap: profileEditVM.isUploadingImage
                    ? null
                    : () async {
                  bool success = await profileEditVM.updateProfileImage();
                  if (!context.mounted) return;
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Profile picture updated"), backgroundColor: Colors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to update picture"), backgroundColor: Colors.red),
                    );
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple.shade50,
                        image: profileEditVM.profileImageUrl != null && profileEditVM.profileImageUrl!.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(profileEditVM.profileImageUrl!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: profileEditVM.profileImageUrl == null || profileEditVM.profileImageUrl!.isEmpty
                          ? Icon(Icons.person, size: 50, color: Colors.deepPurple)
                          : null,
                    ),
                    if (profileEditVM.isUploadingImage)
                      CircularProgressIndicator(color: Colors.deepPurple),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: profileEditVM.isUploadingImage
                  ? null
                  : () async {
                bool success = await profileEditVM.updateProfileImage();
                if (!context.mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Profile picture updated"), backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update picture"), backgroundColor: Colors.red),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.camera, color: Colors.deepPurple, size: 18),
                  SizedBox(width: 5),
                  Text("Change Photo", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 28.0),
              child: Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: profileEditVM.name,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  prefixIcon: Icon(CupertinoIcons.person),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 28.0),
              child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: profileEditVM.email,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  prefixIcon: Icon(CupertinoIcons.mail),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 28.0),
              child: Text("Phone Number", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: profileEditVM.phone,
                decoration: InputDecoration(
                  hintText: "Enter your phone number",
                  prefixIcon: Icon(CupertinoIcons.phone),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 28.0),
              child: Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: profileEditVM.location,
                decoration: InputDecoration(
                  hintText: "Enter your location",
                  prefixIcon: Icon(CupertinoIcons.location_solid),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 18.0, right: 18, bottom: 28),
              child: GestureDetector(
                onTap: () async {
                  bool success = await profileEditVM.saveChanges();
                  if (!context.mounted) return;
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Profile Updated"), backgroundColor: Colors.green),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error updating profile"), backgroundColor: Colors.red),
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
                    child: Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}