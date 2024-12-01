

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/controllers/usercontroller.dart';
import 'package:todo_app/app/models/userdata.dart';
import 'package:todo_app/app/ui_helper/colors.dart';
import '../models/task.dart';

class TaskController extends GetxController{
  var isLoading=false.obs;

  RxList<Task> tasks=<Task>[].obs;

  late Timer _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _startCountdown();
  }

  void _startCountdown(){
    _timer= Timer.periodic(const Duration(seconds: 1), (timer) {
      for (var task in tasks) {
        _updateTaskCountdown(task);
      }
    });
  }


  void _updateTaskCountdown(Task task){
    final now=DateTime.now();
    final deadline=task.deadline;
    if(deadline.isBefore(now)){
      task.remainingMonths=0;
      task.remainingDays=0;
      task.remainingHours=0;
    } else{
      final duration=deadline.difference(now);
      task.remainingMonths=duration.inDays~/30;
      task.remainingDays=duration.inDays % 30;
      task.remainingHours=duration.inHours % 24;
    }
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _timer.cancel();
    super.onClose();
  }




  void toogleTodoStatus(int index,String todostitle){
    tasks[index].todos![todostitle]=!tasks[index].todos![todostitle]!;
    update();
  }

  double calculateProgress(RxMap<String,bool> todos){
    if(todos.isNotEmpty){
      int completedtodos= todos.values.where((isCheked) {
        return isCheked==true;
      },).length;
      update();
      return completedtodos/todos.length;
    } else{
      return 0;
    }

  }


  void addTask(Task task){
    tasks.add(task);
  }

  CustomColors customColors=CustomColors();

  void removeTask(Task task){
    tasks.remove(task);
  }

  void updateTask(int taskIndex,Task updatedTask){
    tasks[taskIndex]=updatedTask;
    update();
  }

  void updateTasksBasedOnUserData(UserData userdata){
    isLoading.value=true;
    tasks=userdata.priorityTasks;
    isLoading.value=false;
    update();
  }

}
