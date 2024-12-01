import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/app/ui_helper/widgets.dart';

import '../controllers/usercontroller.dart';
import '../ui_helper/colors.dart';

class MyprofileScreen extends StatefulWidget{
  @override
  State<MyprofileScreen> createState() => _MyprofileScreenState();
}

class _MyprofileScreenState extends State<MyprofileScreen> {
  final UserController userController = Get.find<UserController>();
  CustomColors customColors = CustomColors();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final emailController=TextEditingController();

  final nameController=TextEditingController();
  final profController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    User? user=FirebaseAuth.instance.currentUser;
    if(user!=null){
      emailController.text=user.email!;
      nameController.text=userController.userData.value.name;
      profController.text=userController.userData.value.profession;
    }

    return Scaffold(
      body:SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: _imageFile == null
                          ? AssetImage('lib/assets/images/sf2.png')
                          : FileImage(File(_imageFile!.path)),

                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                            onTap: () async{
                              XFile? image= await _picker.pickImage(source: ImageSource.gallery);
                              if(image!=null){
                                setState(() {
                                  _imageFile=image;
                                });
                              }
                            },
                            child: Image.asset('lib/assets/images/editicon.png',width: 24,height: 24,))),

                  ],
                ),
              ),
              SizedBox(height: 60,),
              Text('Name',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: customColors.secondColor),),
              SizedBox(height: 10,),
              TextField(
                controller: nameController,
               decoration: InputDecoration(
                   border:  OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                       borderSide: BorderSide(color: Colors.black.withOpacity(0.1))
                   ),
                   enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 borderSide: BorderSide(color: Colors.black.withOpacity(0.1))
               )),
              ),
              SizedBox(height: 20,),
              Text('Profession',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: customColors.secondColor),),
              SizedBox(height: 10,),
              TextField(
                controller:profController ,
                decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.1))
                )),
              ),
              SizedBox(height: 20,),
              Text('Date of Birth',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: customColors.secondColor),),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.1))
                )),
              ),
              SizedBox(height: 20,),
              Text('Email',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: customColors.secondColor),),
              SizedBox(height: 10,),
              TextField(
                enabled: false,
                controller: emailController,
                decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.1))
                )),
              ),
              SizedBox(height: 30,),
              InkWell(
                  onTap: () async{
                    if(nameController.text.isNotEmpty && user !=null){
                      userController.userData.value.name=nameController.text;
                      userController.userData.value.profession=profController.text;
                      userController.uploadData(user.uid);
                      setState(() {
                        Get.offNamed('/home');

                      });


                    }
                  },
                  child: customButton(buttonText: 'Save'))




            ],
          ),
        ),
      ),
    );
  }
}