// ignore_for_file: deprecated_member_use

import 'package:cantu/core/constant/color.dart';
import 'package:flutter/material.dart';
//import 'package:untitled/Core/constant/color.dart';

ThemeData themeEnglish =ThemeData(
fontFamily: "PlayFairDisplay",
        primarySwatch: Colors.blueGrey,
        textTheme: const TextTheme(
            headline1: TextStyle(
              color: AppColor.black, // Text color
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
            headline2: TextStyle(
              color: AppColor.black, // Text color
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            bodyText1: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 2,
                color: Colors.blueGrey)),
      );

      ThemeData themeArabic =ThemeData(
fontFamily: "Cairo",
        primarySwatch: Colors.blueGrey,
        textTheme: const TextTheme(
            headline1: TextStyle(
              color: AppColor.black, // Text color
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
            headline2: TextStyle(
              color: AppColor.black, // Text color
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            bodyText1: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 2,
                color: Colors.blueGrey)),
      );