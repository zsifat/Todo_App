import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:todo_app/app/controllers/usercontroller.dart';
import 'package:todo_app/app/services/authservice.dart';
import 'package:todo_app/app/ui_helper/colors.dart';
import 'package:todo_app/app/ui_helper/widgets.dart';

import '../controllers/daily_task_controller.dart';
import '../controllers/task_controller.dart';

class LoginPage extends StatefulWidget {

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserController userController = Get.find<UserController>();
  final TaskController taskController = Get.find<TaskController>();
  final DailyTasKController dailyTasKController =
  Get.find<DailyTasKController>();
  CustomColors customColors = CustomColors();

  final emailController=TextEditingController();

  final passController=TextEditingController();

  final AuthService _authService=AuthService();
  final _formKey=GlobalKey<FormState>();
  bool _isLoading=false;

  void login() async{
    userController.resetUserData();
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });

      String email=emailController.text.trim();
      String pass=passController.text.trim();

      final user=await _authService.signInWithEmail(email, pass);
      setState(() {
        _isLoading=false;
      });
      if(user!=null){
        await userController.fetchData();
        taskController.updateTasksBasedOnUserData(userController.userData.value);
        dailyTasKController.updateDailyTasksBasedOnUserData(userController.userData.value);
        Get.offNamed('/home');
      }else{
        Get.snackbar('Attention', 'Login failed. Please check your credentials.',backgroundColor: customColors.tenthColor);
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'To do',
                style: GoogleFonts.righteous(
                    color: customColors.secondColor, fontSize: 28),
              ),
              Text(
                'Management App',
                style: GoogleFonts.poppins(
                    color: CupertinoColors.systemGrey, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 60,
              ),
              Text('Login to your account',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 25,
              ),
              Form(
                key: _formKey,
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email,color: customColors.secondColor,),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7),fontSize: 14,fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))
                      ),

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key,color: customColors.secondColor,),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7),fontSize: 14,fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 4) {
                        return 'Password must be at least 4 characters long';
                      }
                      return null;
                    },
                  ),
                ],
              )),
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/forgetpass');

                  },
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.poppins(fontSize: 10,color: customColors.seventhColor),

                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              _isLoading ? CircularProgressIndicator():
              InkWell(
                onTap: () {
                  login();
                },
                  child: customButton(buttonText: 'Login')),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.minus,
                    color: customColors.secondColor,
                  ),
                  Text('OR login with', style: GoogleFonts.poppins(fontSize: 14)),
                  Icon(
                    CupertinoIcons.minus,
                    color: customColors.secondColor,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SignInButton(
                Buttons.google,
                onPressed: () async{
                  final user= await _authService.signInwithGoogle();
                  if (user!=null){
                    await userController.fetchData();
                    taskController.updateTasksBasedOnUserData(userController.userData.value);
                    dailyTasKController.updateDailyTasksBasedOnUserData(userController.userData.value);
                    Get.offNamed('/home');
                  }
                },
                text: 'Sign in with Google',
                elevation: 0.5,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don’t have an account?',
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w500)),
                  TextButton(onPressed: () {
                    Get.toNamed('/signup');
                  }, child: Text('Sign Up', style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w500,color: customColors.secondColor)))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
