import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentseller/view/first%20home.dart';
import 'package:rentseller/view/booking.dart';
import 'package:rentseller/view/sellerprofile.dart';
import 'package:rentseller/view/sellersales.dart';

class Bott extends StatefulWidget {
  const Bott({super.key});

  @override
  State<Bott> createState() => _BottState();
}


class _BottState extends State<Bott> {
  int select = 0;

  List page = [
    SellerHome(),
    SellerBookings(),
    SellerSalesPage(),
    SellerProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: select,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,

        onTap: (index) {
          setState(() {
            select = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: "Bookings",
            icon: Icon(Icons.bookmark),
            activeIcon: Icon(Icons.book_online),
          ),
          BottomNavigationBarItem(
            label: "Sales",
            icon: Icon(Icons.monetization_on_outlined),
            activeIcon: Icon(Icons.monetization_on),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(CupertinoIcons.profile_circled),
            activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),
          ),
        ],
      ),
      body: page[select],
    );
  }
}