import 'package:cantu/controller/onboarding_controller.dart';
import 'package:cantu/core/widget/onboarding/custombutton.dart';
import 'package:cantu/core/widget/onboarding/customslider.dart';
import 'package:cantu/core/widget/onboarding/dotscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OnBoarding extends StatelessWidget {
   const OnBoarding({super.key}); // Constructor for the OnBoarding widget'

  @override
  Widget build(BuildContext context) {
    // Building the UI for the OnBoarding widget
    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 246, 246), // Background color of the scaffold
        body: SafeArea(
    // SafeArea widget to ensure content is displayed within safe areas of the screen

          child: Column(children: [
            Spacer(
              flex: 1,
            ),
            Expanded(
                // Expanded widget to take up remaining space
                flex: 4,
                child: customslider()
            ),
            Expanded(
                // Expanded widget to take up remaining space

                child: Column(
              // Column widget to arrange children vertically
              children: [
                // dots function
                dotscontroller(),

                Spacer(
                  flex: 1,
                ),
                custombuttononboarding(), //custom button function
                Spacer(
                  flex: 1,
                ),
              ],
            ))
          ]),
        ));
  }

}
