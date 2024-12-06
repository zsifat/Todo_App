import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn=GoogleSignIn();

  final customcolors=CustomColors();

  Future<User?> signInwithGoogle() async{
    final GoogleSignInAccount? googleUser= await _googleSignIn.signIn();
    try{
      if(googleUser==null){
        return null;
      }else{
        final GoogleSignInAuthentication googleAuth=await googleUser.authentication;
        AuthCredential credential= GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken);
        UserCredential userCredential= await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    }catch(e){
      Get.showSnackbar(GetSnackBar(
        title: 'Alert',
        message: "Error during Google Sign-In: $e",
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(10),
        borderRadius: 15,
        backgroundColor: customcolors.lightBlue4,
        barBlur: 10,
        dismissDirection: DismissDirection.vertical,
        snackPosition: SnackPosition.TOP,
      ));
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email,String pass) async{
    try {
      UserCredential result=await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      await result.user?.sendEmailVerification();
      Get.showSnackbar(GetSnackBar(
        title: 'Verification Email Sent',
        message: 'Please check your email for verification.',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 15,
        backgroundColor: customcolors.lightBlue4,
        barBlur: 10,
        dismissDirection: DismissDirection.vertical,
        snackPosition: SnackPosition.TOP,
      ));
      return result.user;
    }catch(error){
      Get.showSnackbar(GetSnackBar(
        title: 'Sign-Up Error',
        message: 'Failed to sign up: $error',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 15,
        backgroundColor: customcolors.lightBlue4,
        barBlur: 10,
        dismissDirection: DismissDirection.vertical,
        snackPosition: SnackPosition.TOP,
      ));
      return null;
    }
  }


  Future<User?> signInWithEmail(String email,String pass) async{
    try{
      UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if(result.user!=null && !result.user!.emailVerified){
        Get.showSnackbar(GetSnackBar(
          title: 'Email Verification Pending',
          message: 'Please verify your email before proceeding.',
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 15,
          backgroundColor: customcolors.lightBlue4,
          barBlur: 10,
          dismissDirection: DismissDirection.vertical,
          snackPosition: SnackPosition.TOP,
        ));
        return null;
      }
      return result.user;
    }catch(error){
      Get.showSnackbar(GetSnackBar(
        title: 'Sign-In Error',
        message: 'Please check your credentials.',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 15,
        backgroundColor: customcolors.lightBlue4,
        barBlur: 10,
        dismissDirection: DismissDirection.vertical,
        snackPosition: SnackPosition.TOP,
      ));
      return null;
    }
  }
  Future<void> checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      // Show a message and ask the user to verify the email
      Get.showSnackbar(GetSnackBar(
        title: 'Email Not Verified',
        message: 'Please verify your email to continue.',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 15,
        backgroundColor: customcolors.lightBlue4,
        barBlur: 10,
        dismissDirection: DismissDirection.vertical,
        snackPosition: SnackPosition.TOP,
      ));
    } else if (user != null && user.emailVerified) {
      // Navigate to the home screen if email is verified
      Get.offNamed('/home');
    }
  }

  Future<void> signOut() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

}