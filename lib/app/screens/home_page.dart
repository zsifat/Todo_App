import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app/controllers/darkmode_controller.dart';
import 'package:todo_app/app/screens/CalenderScreen.dart';
import 'package:todo_app/app/screens/profilepage.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import '../controllers/daily_task_controller.dart';
import '../controllers/task_controller.dart';
import '../controllers/usercontroller.dart';
import 'addtaskscreen.dart';
import 'dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final customColors = const CustomColors();

  int selectedIndex = 0;

  final List<Widget> _screens = [
    Dashboard(),
    CalenderScreen(),
    ProfileScreen()
  ];
  final TaskController taskController = Get.find<TaskController>();
  final DailyTasKController dailyTasKController =
      Get.find<DailyTasKController>();
  final UserController userController = Get.find<UserController>();
  final themeContoller = Get.find<DarkModeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            await userController.fetchData();
            taskController
                .updateTasksBasedOnUserData(userController.userData.value);
            dailyTasKController
                .updateDailyTasksBasedOnUserData(userController.userData.value);
          },
          child: _screens[selectedIndex]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            onTap: (value) async {
              setState(() {
                selectedIndex = value;
              });
            },
            enableFeedback: true,
            backgroundColor:
                themeContoller.isDarkMode.value ? Colors.black : Colors.white,
            showUnselectedLabels: false,
            showSelectedLabels: true,
            selectedLabelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12),
            selectedItemColor:
                Get.isDarkMode ? Colors.white : customColors.secondaryColor,
            currentIndex: selectedIndex,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Image.asset(
                  'lib/assets/images/homeicon.png',
                  height: 27,
                  width: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Calender',
                icon: Image.asset(
                  'lib/assets/images/calendericon.png',
                  height: 27,
                  width: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: Image.asset(
                  'lib/assets/images/profileicon.png',
                  height: 27,
                  width: 25,
                ),
              )
            ]),
      ),
    );
  }
}
