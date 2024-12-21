import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import '../ui_helper/widgets.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});
  final customColors = const CustomColors();
  final TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar('', 'Password reset email sent!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 70,
            ),
            Text(
              'To do',
              style: GoogleFonts.righteous(
                  color: customColors.secondaryColor, fontSize: 28),
            ),
            Text(
              'Management App',
              style: GoogleFonts.poppins(
                  color: CupertinoColors.systemGrey,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 60,
            ),
            const Spacer(
              flex: 1,
            ),
            Text('Enter Your Email',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: customColors.secondaryColor,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.3))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () {
                  resetPassword();
                  Get.offNamed('/login');
                },
                child: customButton(buttonText: 'Login')),
            const Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
