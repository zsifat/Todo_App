import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/app/services/authservice.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import '../controllers/usercontroller.dart';
import '../ui_helper/widgets.dart';

class ProfileScreen extends StatelessWidget{
  final UserController userController = Get.find<UserController>();
  AuthService _authService=AuthService();
  CustomColors customColors = CustomColors();
  @override
  Widget build(BuildContext context) {
    User? user=FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('lib/assets/images/sf2.png'),
              ),
              SizedBox(height: 8,),
              Text(userController.userData.value.name,style:GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600,color:customColors.secondColor),),
              Text(userController.userData.value.profession,style:GoogleFonts.poppins(
                  fontSize: 12 ,fontStyle: FontStyle.italic,fontWeight: FontWeight.w500),),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/myprofile');
                  },
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.profile_circled,color: customColors.secondColor,size: 30,),
                      SizedBox(width: 20,),
                      Text('My Profile',style:GoogleFonts.poppins(
                          fontSize: 16,fontWeight: FontWeight.w500  ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.chart_bar_square_fill,color: customColors.secondColor,size: 30,),
                    SizedBox(width: 20,),
                    Text('Statistics',style:GoogleFonts.poppins(
                        fontSize: 16,fontWeight: FontWeight.w500  )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.location_solid,color: customColors.secondColor,size: 30,),
                    SizedBox(width: 20,),
                    Text('Location',style:GoogleFonts.poppins(
                        fontSize: 16,fontWeight: FontWeight.w500  ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Icon(Icons.settings,color: customColors.secondColor,size: 30,),
                    SizedBox(width: 20,),
                    Text('Settings',style:GoogleFonts.poppins(
                        fontSize: 16,fontWeight: FontWeight.w500  )),
                  ],
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
                      Icon(Icons.logout,color: customColors.secondColor,size: 30,),
                      SizedBox(width: 20,),
                      Text('Logout',style:GoogleFonts.poppins(
                          fontSize: 16,fontWeight: FontWeight.w500 )),
                    ],
                  ),
                ),
              ),



            ],
          ),
        ),
      )
    );
  }

}