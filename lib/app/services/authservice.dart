import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/app/ui_helper/colors.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final customcolors = const CustomColors();

  static const int _signInTimeoutSeconds = 30;

  Future<User?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signIn()
          .timeout(const Duration(seconds: _signInTimeoutSeconds));

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on TimeoutException {
      _showError('Sign In Timeout',
          'The sign in process took too long. Please try again.');
      return null;
    } catch (e) {
      _showError(
          'Google Sign-In Error', _getReadableErrorMessage(e.toString()));
      return null;
    }
  }

  void _showError(String title, String message) {
    Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 15,
      backgroundColor: customcolors.lightBlue4,
      barBlur: 10,
      dismissDirection: DismissDirection.vertical,
      snackPosition: SnackPosition.TOP,
    ));
  }

  String _getReadableErrorMessage(String error) {
    if (error.contains('network-request-failed')) {
      return 'Please check your internet connection';
    } else if (error.contains('invalid-email')) {
      return 'The email address is badly formatted';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled';
    } else if (error.contains('user-not-found')) {
      return 'No user found with this email';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (error.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later';
    }
    return 'An unexpected error occurred. Please try again';
  }

  Future<User?> signUpWithEmail(String email, String pass) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
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
    } catch (error) {
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

  Future<User?> signInWithEmail(String email, String pass) async {
    try {
      final result = await _auth
          .signInWithEmailAndPassword(email: email.trim(), password: pass)
          .timeout(const Duration(seconds: _signInTimeoutSeconds));

      if (result.user == null) return null;

      if (!result.user!.emailVerified) {
        _showError('Email Verification Required',
            'Please verify your email before signing in. Check your inbox for the verification link.');
        return null;
      }

      return result.user;
    } on TimeoutException {
      _showError('Sign In Timeout',
          'The sign in process took too long. Please try again.');
      return null;
    } catch (error) {
      _showError('Sign In Failed', _getReadableErrorMessage(error.toString()));
      return null;
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _showError('Verification Email Sent',
            'A new verification email has been sent to your email address.');
      }
    } catch (e) {
      _showError('Error',
          'Failed to send verification email. Please try again later.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _showError('Password Reset Email Sent',
          'Please check your email for password reset instructions.');
    } catch (e) {
      _showError('Error', _getReadableErrorMessage(e.toString()));
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

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
