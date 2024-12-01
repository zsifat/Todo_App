import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

class slideIndicatorCircle extends StatelessWidget {
  final int index;

  slideIndicatorCircle(this.index);

  var customColor = CustomColors();

  @override
  Widget build(BuildContext context) {
    Color color1 = Color(0xFFEEF5FD);
    Color color2 = Color(0xFFEEF5FD);
    Color color3 = Color(0xFFEEF5FD);

    if (index == 0) {
      color1 = customColor.secondColor;
    } else if (index == 1) {
      color2 = customColor.secondColor;
    } else if (index == 2) {
      color3 = customColor.secondColor;
    }
    return Row(
      children: [
        Container(
          width: 10,
          margin: EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color1),
        ),
        Container(
          width: 10,
          margin: EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color2),
        ),
        Container(
          width: 10,
          margin: EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color3),
        ),
      ],
    );
  }
}

class customButton extends StatelessWidget{
  final String buttonText;
  customButton({required this.buttonText});

  var customColor = CustomColors();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: customColor.secondColor
      ),
      child: Center(child: Text(buttonText,style: GoogleFonts.poppins(color: Colors.white),)),
    );
  }
}



