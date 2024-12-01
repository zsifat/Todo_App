import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/controllers/usercontroller.dart';
import 'package:todo_app/app/routes/app_page.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import 'app/controllers/daily_task_controller.dart';
import 'app/controllers/task_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(TaskController());
  Get.put(DailyTasKController());
  Get.put(UserController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To-Do list App',
      initialRoute: '/splash',
      getPages: AppPage.pages,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
        )
      ),



    );
  }

}