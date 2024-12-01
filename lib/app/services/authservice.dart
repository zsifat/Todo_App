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
        backgroundColor: customcolors.sixthColor,
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
      return result.user;
    }catch(error){
      print('Error: $error');
      return null;
    }
  }


  Future<User?> signInWithEmail(String email,String pass) async{
    try{
      UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return result.user;
    }catch(error){
      print('Error: $error');
      return null;
    }
  }

  Future<void> signOut() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

}