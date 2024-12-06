import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app/data/get_started_data.dart';
import 'package:todo_app/app/ui_helper/colors.dart';
import 'package:todo_app/app/ui_helper/widgets.dart';

import '../controllers/daily_task_controller.dart';
import '../controllers/task_controller.dart';
import '../controllers/usercontroller.dart';

class GetStartedScreen extends StatelessWidget {
  final int index;
  GetStartedScreen({super.key,required this.index});
  final TaskController taskController = Get.find<TaskController>();
  final DailyTasKController dailyTaskController =
  Get.find<DailyTasKController>();
  final UserController userController = Get.find<UserController>();

  Future<void> _handleSkipButtonPressed() async {
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null) {
      await userController.fetchData();
      taskController.updateTasksBasedOnUserData(userController.userData.value);
      dailyTaskController.updateDailyTasksBasedOnUserData(userController.userData.value);
      Get.offNamed('/home');
    }else{
      Get.offNamed('/login');
    }
  }

  final customColors = CustomColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [slideIndicatorCircle(index)],
        ),
        actions: [
          TextButton(
              onPressed:() {
                _handleSkipButtonPressed();
              },
              child: Text(
                'skip',
                style: GoogleFonts.poppins(
                    color: customColors.secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(allGetStartData[index].imagePath),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    allGetStartData[index].title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(allGetStartData[index].text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 12)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
                onTap: () async{
                  if(index==0){
                    Get.offNamed('/gssecond',);
                  }else if(index==1){
                    Get.offNamed('/gsthird');
                  }else{
                    await _handleSkipButtonPressed();

                  }
                },
                child: customButton(buttonText: 'Get Started',)),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }


}
