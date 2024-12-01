import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app/screens/CalenderScreen.dart';
import 'package:todo_app/app/screens/profilepage.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import 'addtaskscreen.dart';
import 'dashboard.dart';

class HomePage extends StatefulWidget{
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final customColors=CustomColors();

  int selectedIndex=0;

  final List<Widget> _screens = [
    Dashboard(),
    CalenderScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              selectedIndex=value;
            });
          },
          enableFeedback: true,
          backgroundColor: Colors.white,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12),
          selectedItemColor: customColors.secondColor,
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon:Image.asset(
                'lib/assets/images/homeicon.png',
                height: 27,
                width: 25,
              ),),
            BottomNavigationBarItem(
              label: 'Calender',
              icon: Image.asset(
                'lib/assets/images/calendericon.png',
                height: 27,
                width: 25,
              ),),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Image.asset('lib/assets/images/profileicon.png',
                height: 27,
                width: 25,
              ),)
          ]),
    );
  }
}