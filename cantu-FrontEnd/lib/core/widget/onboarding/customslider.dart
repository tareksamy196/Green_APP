// ignore_for_file: camel_case_types

import 'package:cantu/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cantu/core/constant/color.dart';
import 'package:cantu/controller/onboarding_controller.dart';

class customslider extends StatelessWidget {
  const  customslider({super.key });
  @override
  Widget build(BuildContext context) {
    OnBoardingControllerImp controller = Get.put(OnBoardingControllerImp());
    return PageView.builder(
      controller: controller.pagecontroller,
      onPageChanged: (val) {
        controller.onPagechanged(val);
      },
      itemCount: onBoardingList.length, // Total number of pages in the PageView
      itemBuilder: (context, i) =>
          Column(// Builder function for constructing each page
              children: [
        Text(
          // Text widget to display title  
          onBoardingList[i].title!, // Title text retrieved from data source
          style: const TextStyle(
              color: AppColor.black, // Text color
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),),
        
        Image.asset(
          // Image widget to display image
          onBoardingList[i].image!,
              height: context.width /1.3,
              fit: BoxFit.fill, // Image asset path retrieved from data source
          //height: 300, // Image height
        ),
        const SizedBox(height: 40), // SizedBox widget for adding fixed height
        Container(
            // Container widget to hold body text
            width: double.infinity, // Container width to occupy entire width
            alignment: Alignment.center, // Alignment of the container
            child: Text(
                onBoardingList[i].body!, // Body text retrieved from data source
                textAlign: TextAlign.center, // Text alignment
                style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 2,
                color: Colors.blueGrey)))
      ]),
    );
  }
}
