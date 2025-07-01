// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/routes.dart';

class custombuttononboarding extends StatelessWidget {
  const custombuttononboarding({Key? Key}) : super(key: Key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container widget to hold continue button
      margin: const EdgeInsets.only(bottom: 30),
      // Background color of the container
      color: const Color.fromARGB(255, 86, 193, 105), // Margin of the container
      child: MaterialButton(
        // MaterialButton widget for the continue button
        padding: // Padding of the button
            const EdgeInsets.symmetric(horizontal: 60, vertical: 2),

        onPressed: ()  {
          Navigator.pushNamed(context, AppRoute.language);
        },

        child: const Text(
          // Text widget for the button text
          "Continue", // Button text
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15), // Text style for the button text
        ),
      ),
    );
  }

}
