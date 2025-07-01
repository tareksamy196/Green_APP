

import 'package:cantu/core/constant/routes.dart';
import 'package:cantu/core/services/services.dart';
import 'package:cantu/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class OnBoardingController extends GetxController {
  next();
  onPagechanged(int index);
}

class OnBoardingControllerImp extends OnBoardingController {
  late PageController pagecontroller;

  int CurrentPage = 0;
  MyServices myServices = Get.find();

  @override
  next() {
    CurrentPage++;
    if (CurrentPage > onBoardingList.length - 1) {
      myServices.sharedPreferences.setString("onboarding", "1");
      Get.offAllNamed(AppRoute.login);
    } else {
      pagecontroller.animateToPage(CurrentPage,
          duration: const Duration(milliseconds: 900), curve: Curves.easeInOut);
    }
  }

  @override
  onPagechanged(int index) {
    CurrentPage = index;
    update();
  }

  @override
  void onInit() {
    pagecontroller = PageController();
    super.onInit();
  }
}
