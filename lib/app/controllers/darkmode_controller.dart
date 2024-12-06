import 'package:get/get.dart';

class DarkModeController extends GetxController{
  var isDarkMode=false.obs;

  void togleMode(bool value){
    isDarkMode.value=value;
  }
}