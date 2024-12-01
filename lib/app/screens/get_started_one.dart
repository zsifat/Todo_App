import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app/data/get_started_data.dart';
import 'package:todo_app/app/ui_helper/colors.dart';
import 'package:todo_app/app/ui_helper/widgets.dart';

class GetStartedScreen extends StatelessWidget {
  final int index;
  GetStartedScreen({super.key,required this.index});

  var customColors = CustomColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [slideIndicatorCircle(index)],
        ),
        actions: [
          TextButton(
              onPressed: () => Get.offNamed('/home'),
              child: Text(
                'skip',
                style: GoogleFonts.poppins(
                    color: customColors.secondColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(allGetStartData[index].imagePath),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    allGetStartData[index].title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(allGetStartData[index].text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 12)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
                onTap: () {
                  if(index==0){
                    Get.offNamed('/gssecond',);
                  }else if(index==1){
                    Get.offNamed('/gsthird');
                  }else{
                    Get.offNamed('/login');
                  }
                },
                child: customButton(buttonText: 'Get Started',)),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
