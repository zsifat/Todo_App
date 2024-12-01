

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CustomColors customColors=CustomColors();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),() {
      Get.offNamed('/gsfirst');
    },);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Image.asset('lib/assets/images/splashlogo.png')
        ),
    );
  }
}