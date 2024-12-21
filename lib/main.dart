import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/controllers/darkmode_controller.dart';
import 'package:todo_app/app/controllers/usercontroller.dart';
import 'package:todo_app/app/routes/app_page.dart';

import 'app/controllers/daily_task_controller.dart';
import 'app/controllers/task_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(TaskController());
  Get.put(DailyTasKController());
  Get.put(UserController());
  Get.put(DarkModeController());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final darkmodeController = Get.find<DarkModeController>();

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isDarkmode = prefs.getBool('isDarkMode');
    darkmodeController.isDarkMode.value = isDarkmode ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'To-Do list App',
        initialRoute: '/splash',
        getPages: AppPage.pages,
        debugShowCheckedModeBanner: false,
        themeMode: darkmodeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            )),
      ),
    );
  }
}
