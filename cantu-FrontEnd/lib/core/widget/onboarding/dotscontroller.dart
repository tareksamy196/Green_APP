// ignore_for_file: camel_case_types

import 'package:cantu/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cantu/controller/onboarding_controller.dart';

class dotscontroller extends StatelessWidget {
  const dotscontroller({super.key});

  @override //show change of pages on ui
  Widget build(BuildContext context) {

    return GetBuilder<OnBoardingControllerImp>(builder: (controller)=>Row(
      // Row widget to arrange children horizontally

      mainAxisAlignment:
          MainAxisAlignment.center, // Main axis alignment of the row
      children: [
        ...List.generate(
            // Generating list of widgets
            onBoardingList.length, // Total number of widgets to generate
            (index) => AnimatedContainer(
                  // AnimatedContainer widget for animating the container
                  margin: const EdgeInsets.only(
                      right: 5), // Margin of the container
                  duration:
                      const Duration(milliseconds: 900), // Duration of the animation
                  width: controller.CurrentPage==index?20:5, // Width (depend on controller)
                  height: 6, // Height of the container
                  decoration: BoxDecoration(
                      // Decoration of the container
                      color: const Color.fromARGB(255, 41, 100, 71),
                      borderRadius: BorderRadius.circular(
                          10)), // Border radius of the container
                ))
      ],
    ));
  }
}
