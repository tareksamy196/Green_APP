import 'package:cantu/core/constant/routes.dart';
import 'package:cantu/data/ApiService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/profileModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _getUser(String access) async {
    ApiService api = ApiService();
    try {
      Profile? profile = await api.fetchProfile();
      if(profile == null){
        Navigator.pushReplacementNamed(context, AppRoute.login);
      }
      if (profile!.isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoute.admin);
      } else {
        Navigator.pushReplacementNamed(context, AppRoute.home);
      }
    } catch (e) {
      // Handle error and possibly navigate to an error screen or show a message
      print('Error: $e');
    }
  }

  void _sync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool("first") ?? true;
    Future.delayed(const Duration(milliseconds: 2400),(){
      if(firstTime){
        Navigator.pushNamed(context, AppRoute.onBoarding);
      }else{
        String access = prefs.getString("access_token") ?? "";
        if (kDebugMode) {
          print(access);
          print(access.isEmpty);
        }
        if(access.isEmpty){
          Navigator.pushNamed(context, AppRoute.login);
        }else{
          _getUser(access);
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _sync();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the column contents
        children: [
          Expanded(
            child: Center(
              child: Text("Cantu",style: Theme.of(context).textTheme.displayLarge
                  ?.copyWith(color: Colors.green.shade900,fontWeight: FontWeight.w500)
              ),
            ),
          ),
          const Spacer(), // Pushes the image to the bottom

          SvgPicture.asset('assets/images/splash.svg')
        ],
      ),
    );
  }
}
