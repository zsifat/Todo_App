import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/app/controllers/darkmode_controller.dart';
import 'package:todo_app/app/screens/forget_password.dart';
import 'package:todo_app/app/services/authservice.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import '../controllers/usercontroller.dart';
import '../ui_helper/widgets.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final darkController = Get.find<DarkModeController>();
  final AuthService _authService = AuthService();
  CustomColors customColors = const CustomColors();

  ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(body: Obx(
      () {
        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  userController.userData.value.name,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: customColors.secondaryColor),
                ),
                Text(
                  userController.userData.value.profession,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/myprofile');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.profile_circled,
                          color: customColors.secondaryColor,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text('My Profile',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: customColors.secondaryColor,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text('Dark Mode',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          trackOutlineColor:
                              WidgetStatePropertyAll(customColors.primaryColor),
                          inactiveThumbColor: customColors.primaryColor,
                          inactiveTrackColor: Colors.white,
                          activeColor: customColors.primaryColor,
                          value: darkController.isDarkMode.value,
                          onChanged: (value) async {
                            darkController.togleMode(value);
                            var prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isDarkMode', value);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: user!.email!);
                      Get.snackbar('', 'Password reset email sent!',
                          duration: const Duration(seconds: 3));
                    } catch (e) {
                      Get.snackbar('Error', e.toString());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.password,
                          color: customColors.secondaryColor,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text('Change Password',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: InkWell(
                    onTap: () {
                      userController.resetUserData();
                      _authService.signOut();
                      Get.offNamed('/login');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: customColors.secondaryColor,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text('Logout',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
