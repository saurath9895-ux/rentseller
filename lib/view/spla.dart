import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:rentseller/view/loginview.dart';

class Spla extends StatefulWidget {
  const Spla({super.key});
  @override
  State<Spla> createState() => _SplaState();
}

class _SplaState extends State<Spla> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginView()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginView()));
          },
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("lib/image/ChatGPT Image Oct 7, 2026, 12_42_27 AM.png"))
            ),
          ),
        ),
      ),
    );
  }
}