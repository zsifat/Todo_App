import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/controllers/daily_task_controller.dart';
import 'package:todo_app/app/controllers/task_controller.dart';
import 'package:todo_app/app/controllers/usercontroller.dart';
import 'package:todo_app/app/data/tasks.dart';
import 'package:todo_app/app/models/daily_task.dart';
import 'package:todo_app/app/screens/addtaskscreen.dart';
import 'package:todo_app/app/screens/profilepage.dart';
import 'package:todo_app/app/ui_helper/widgets.dart';

import '../controllers/darkmode_controller.dart';
import '../ui_helper/colors.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CustomColors customColors = CustomColors();

  double _Dailyprogress(RxList<DailyTask> dailytasks) {
    int totalcompleted = dailytasks
        .where(
          (dtask) {
            return dtask.isChecked == true;
          },
        )
        .toList()
        .length;
    return totalcompleted / dailytasks.length;
  }


  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();
    final DailyTasKController dailyTasKController =
        Get.find<DailyTasKController>();
    final UserController userController = Get.find<UserController>();
    final themeContoller=Get.find<DarkModeController>();

    User? user=FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Obx(
            () {
              if(taskController.isLoading.value){
                return CircularProgressIndicator();
              }else{
                double dprogess = _Dailyprogress(dailyTasKController.dailytasks);
                return RefreshIndicator(
                  onRefresh: () async{
                  await userController.fetchData();
                  taskController.updateTasksBasedOnUserData(userController.userData.value);
                  dailyTasKController.updateDailyTasksBasedOnUserData(userController.userData.value);
                },
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wellcome ${userController.userData.value.name}',
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Have a nice day',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                        Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            Get.toNamed('/addtask');
                          },
                          icon: Icon(Icons.add),
                          label: Text(
                            'Add Task',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: customColors.secondaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Tasks',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton.icon(
                            onPressed: () async{
                              await userController.fetchData();
                              taskController.updateTasksBasedOnUserData(userController.userData.value);
                              dailyTasKController.updateDailyTasksBasedOnUserData(userController.userData.value);
                            }, label: Text('Sync',style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: customColors.secondaryColor),),
                        icon: Icon(Icons.refresh,color: customColors.primaryColor,),),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    taskController.tasks.isNotEmpty ? Container(
                        height: 188,
                        child: ListView.builder(
                          itemCount: taskController.tasks.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed('/detailsscreen', arguments: index);
                              },
                              onLongPress: () {
                                Get.dialog(
                                    AlertDialog(
                                    title: Text('Delete this task?',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  titlePadding: EdgeInsets.only(
                                      left: 24, top: 24, bottom: 16),
                                    content: Text(
                                      'This is permanent and can\'t be undone',
                                      style: GoogleFonts.poppins(fontSize: 12)),
                                  contentPadding: EdgeInsets.only(
                                      left: 24, bottom: 14, right: 24),
                                  actionsPadding: EdgeInsets.only(right: 16),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('Cancel',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12, color: Colors.black)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        taskController.removeTask(
                                            taskController.tasks[index]);
                                        userController.uploadData(user!.uid);
                                      },
                                      child: Text('Delete',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: customColors.secondaryColor)),
                                    ),
                                  ],
                                ));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 9),
                                padding: const EdgeInsets.all(12),
                                height: 188,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: taskController.tasks[index].colors,
                                    // Soft sky blue], // Peach to soft orange
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Obx(
                                      () {
                                    var progress =
                                    taskController.calculateProgress(
                                        taskController.tasks[index].todos!);
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: themeContoller.isDarkMode.value ? Colors.black : Colors.white),
                                              child: Text(
                                                '${taskController.tasks[index].deadline.difference(taskController.tasks[index].startDate).inDays} days',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Center(
                                              child: Text(
                                                taskController.tasks[index].title,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                        LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 7,
                                          color: Colors.white,
                                          backgroundColor:
                                          customColors.lightBlue5,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                                '${(progress * 100).toStringAsFixed(0)}%',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        )) : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(child: Text('Click on \'Add task\' to add new task',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: themeContoller.isDarkMode.value ? Colors.white : customColors.secondaryColor,
                          fontWeight: FontWeight.w500),)),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Daily Task',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    dailyTasKController.dailytasks.isNotEmpty ? Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10),
                      child: SizedBox(
                        height: 30,
                        child: Stack(
                          children: [
                            LinearProgressIndicator(
                              value: dprogess,
                              minHeight: 24,
                              color: customColors.secondaryColor,
                              backgroundColor: customColors.lightBlue5,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      '${(dprogess * 100).toStringAsFixed(1)}%',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 12))),
                            )
                          ],
                        ),
                      ),
                    ) : const SizedBox.shrink(),
                    dailyTasKController.dailytasks.isNotEmpty ?
                    Flexible(
                      child: ListView.builder(
                        itemCount: dailyTasKController.dailytasks.length,
                        itemBuilder: (context, index) {
                          return Obx(
                                () {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10, right: 10),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: Colors.grey.withOpacity(0.2))),
                                  title: Text(
                                      dailyTasKController.dailytasks[index].title,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: customColors.secondaryColor)),
                                  trailing: Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3)),
                                    checkColor: Colors.white,
                                    activeColor: customColors.secondaryColor,
                                    side: BorderSide(
                                        color: customColors.secondaryColor,
                                        width: 2),
                                    value: dailyTasKController
                                        .dailytasks[index].isChecked,
                                    onChanged: (value) {
                                      dailyTasKController.togleIsChecked(index);
                                    },
                                  ),
                                  onLongPress: () {
                                    Get.dialog(AlertDialog(
                                      title: Text('Delete this Task?',
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      titlePadding: const EdgeInsets.only(
                                          left: 24, top: 24, bottom: 16),
                                      content: Text(
                                          'This is permanent and can\'t be undone',
                                          style:
                                          GoogleFonts.poppins(fontSize: 12)),
                                      contentPadding: const EdgeInsets.only(
                                          left: 24, bottom: 14, right: 24),
                                      actionsPadding: const EdgeInsets.only(right: 16),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text('Cancel',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.black)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                            dailyTasKController.removeDailyTask(
                                                dailyTasKController
                                                    .dailytasks[index]);
                                            Get.showSnackbar(const GetSnackBar(
                                              message: "Daily Task Removed",
                                              duration: Duration(seconds: 2),
                                              dismissDirection:
                                              DismissDirection.down,
                                            ));
                                          },
                                          child: Text('Delete',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color:
                                                  customColors.secondaryColor)),
                                        ),
                                      ],
                                    ));
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ) : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(child: Text('Click on \'Add task\' to add new task',style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: themeContoller.isDarkMode.value ? Colors.white : customColors.secondaryColor,
                      fontWeight: FontWeight.w500),)),
                    )
                  ],
                  ),
                );}
            },
          ),
        ),
      ),
    );
  }
}


