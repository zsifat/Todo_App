import 'package:get/get.dart';
import 'package:todo_app/app/screens/addtaskscreen.dart';
import 'package:todo_app/app/screens/dashboard.dart';
import 'package:todo_app/app/screens/forget_password.dart';
import 'package:todo_app/app/screens/get_started_one.dart';
import 'package:todo_app/app/screens/home_page.dart';
import 'package:todo_app/app/screens/login_page.dart';
import 'package:todo_app/app/screens/myprofile.dart';
import 'package:todo_app/app/screens/profilepage.dart';
import 'package:todo_app/app/screens/signup_page.dart';
import 'package:todo_app/app/screens/splash_screen.dart';
import 'package:todo_app/app/screens/task_details.dart';

class AppPage {
  static final pages = [
    GetPage(
        name: '/home',
        page: () => HomePage(),
        transition: Transition.noTransition),
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
    ),
    GetPage(
        name: '/gsfirst',
        page: () => GetStartedScreen(
              index: 0,
            ),
        transition: Transition.noTransition),
    GetPage(
        name: '/gssecond',
        page: () => GetStartedScreen(
              index: 1,
            ),
        transition: Transition.noTransition),
    GetPage(
        name: '/gsthird',
        page: () => GetStartedScreen(
              index: 2,
            ),
        transition: Transition.noTransition),
    GetPage(
        name: '/login',
        page: () => LoginPage(),
        transition: Transition.noTransition),
    GetPage(
        name: '/signup',
        page: () => SignupPage(),
        transition: Transition.noTransition),
    GetPage(
        name: '/dashboard',
        page: () => Dashboard(),
        transition: Transition.noTransition),
    GetPage(
        name: '/detailsscreen',
        page: () => TaskDetailsScreen(taskindex: Get.arguments as int),
        transition: Transition.noTransition),
    GetPage(
      name: '/addtask',
      page: () => const AddTaskScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/myprofile',
      page: () => MyprofileScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/forgetpass',
      page: () => ForgetPassword(),
      transition: Transition.noTransition,
    ),
  ];
}
