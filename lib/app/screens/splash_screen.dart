import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/daily_task_controller.dart';
import '../controllers/task_controller.dart';
import '../controllers/usercontroller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TaskController taskController = Get.find<TaskController>();
  final DailyTasKController dailyTasKController = Get.find<DailyTasKController>();
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    final isFirstTime = await _checkFirstTime();

    if (isFirstTime) {
      Get.offNamed('/gsfirst');
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await userController.fetchData();
        taskController.updateTasksBasedOnUserData(userController.userData.value);
        dailyTasKController.updateDailyTasksBasedOnUserData(userController.userData.value);
        Get.offNamed('/home');
      } else {
        Get.offNamed('/login');
      }
    }
  }

  Future<bool> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('lib/assets/images/splashlogo.png'),
      ),
    );
  }
}
