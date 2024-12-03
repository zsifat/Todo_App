import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/data/tasks.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  TaskDetailsScreen({super.key, required this.taskindex});

  final int taskindex;

  CustomColors customColors = CustomColors();


  @override
  Widget build(BuildContext context) {
    final TaskController taskController=Get.find();
    final task=taskController.tasks[taskindex];
    var progress=0;


    return Scaffold(
      body: SafeArea(
        child: Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: customColors.secondColor),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.offNamed('/addtask',arguments: task);
                    },
                    icon: Icon(Icons.edit,size: 16,),
                    label: Text(
                      'Edit Task',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: customColors.secondColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'start',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${DateFormat('dd MMM yyyy').format(task.startDate)}',style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 12),)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'end',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                          '${DateFormat('dd MMM yyyy').format(task.deadline)}',style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 12))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: customColors.secondColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                                task.remainingMonths.toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 38),
                              )),
                          Text('months',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: customColors.secondColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                                task.remainingDays.toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34),
                              )),
                          Text('days',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: customColors.secondColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                                task.remainingHours.toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34),
                              )),
                          Text('hours',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Text('Description',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 14)),
              SizedBox(height: 5,),
              Text(task.description,style: GoogleFonts.poppins(fontSize: 12),textAlign: TextAlign.left,),
              SizedBox(height: 50,),
              Text('Progress',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 14)),
              SizedBox(height: 5,),
              Obx(() {
                var progress=taskController.calculateProgress(taskController.tasks[taskindex].todos!);
                return Stack(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 24,
                      color: customColors.secondColor,
                      backgroundColor: Color(0xFFA9A2A2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text('${(progress*100).toStringAsFixed(1)}%',style: GoogleFonts.poppins(color: Colors.white,fontSize: 12))),
                    )
                  ],
                );
              },),
              SizedBox(height: 20,),
              Text('To do List',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 14)),

              Expanded(
                child: task.todos!.isEmpty ? SizedBox.shrink() : Obx(() {
                  return ListView.builder(
                    itemCount: task.todos!.length,
                    itemBuilder:(context, index) {
                      var title=task.todos!.keys.toList()[index];
                      bool isCheked= task.todos![title]!;
                      return ListTile(
                        title: Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 14,color: customColors.secondColor)),
                        trailing: Checkbox(
                          fillColor: WidgetStateProperty.all(customColors.secondColor),
                          side: BorderSide(color: Colors.transparent),
                          value: isCheked, onChanged: (value) {
                          taskController.toogleTodoStatus(taskindex,task.todos!.keys.toList()[index]);
                        },),
                      );
                    }, );
                },),
              ),

            ],
          ),
        ),),
      ),
    );
  }
}
