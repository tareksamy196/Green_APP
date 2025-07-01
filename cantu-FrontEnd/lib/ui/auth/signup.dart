
 
import 'package:cantu/controller/auth/signup_controller.dart';
import 'package:cantu/core/constant/color.dart';
import 'package:cantu/core/functions/alertexitapp.dart';
import 'package:cantu/core/functions/validinput.dart';
import 'package:cantu/core/widget/auth/custombuttonauth.dart';
import 'package:cantu/core/widget/auth/customtextbodyauth.dart';
import 'package:cantu/core/widget/auth/customtextformauth.dart';
import 'package:cantu/core/widget/auth/customtexttitleauth.dart';
import 'package:cantu/core/widget/auth/textsignup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../I18n.dart';
import '../../core/constant/routes.dart';
import '../../data/ApiService.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  SignUpControllerImp controller = Get.put(SignUpControllerImp());
  var api = ApiService();
  Future<void> _signup(BuildContext context) async {
    api.signup(controller.username.text,controller.email.text, controller.phone.text,controller.password.text).then((success) {
      if (success) {
        Navigator.pushNamed(context, AppRoute.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green.shade50,
        elevation: 0.0,
        title: Text(AppLocalizations.of(context).translate('signup'),
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: AppColor.grey)),
      ),
      body: WillPopScope(
          onWillPop: alertExitApp,
          child: Container(
            color: Colors.green.shade50,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Form(
              key: controller.formstate,
              child: ListView(children: [
                const SizedBox(height: 20),
                CustomTextTitleAuth(text: AppLocalizations.of(context).translate('title')),
                const SizedBox(height: 10),
                CustomTextBodyAuth(text: AppLocalizations.of(context).translate('signup_message')),
                const SizedBox(height: 15),
                CustomTextFormAuth(
                  isNumber: false,
                  valid: (val) {
                    return validInput(val!, 3, 20, "username");
                  },
                  mycontroller: controller.username,
                  hinttext: AppLocalizations.of(context).translate('username_hint'),
                  iconData: Icons.person_outline,
                  labeltext: AppLocalizations.of(context).translate('username'),
                  // mycontroller: ,
                ),
                CustomTextFormAuth(
                  isNumber: false,

                  valid: (val) {
                    return validInput(val!, 3, 40, "email");
                  },
                  mycontroller: controller.email,
                  hinttext: AppLocalizations.of(context).translate('email_hint'),
                  iconData: Icons.email_outlined,
                  labeltext: AppLocalizations.of(context).translate('email'),
                  // mycontroller: ,
                ),
                CustomTextFormAuth(
                  isNumber: true,
                  valid: (val) {
                    return validInput(val!, 7, 11, "phone");
                  },
                  mycontroller: controller.phone,
                  hinttext: AppLocalizations.of(context).translate('phone_hint'),
                  iconData: Icons.phone_android_outlined,
                  labeltext: AppLocalizations.of(context).translate('phone'),
                  // mycontroller: ,
                ),
                CustomTextFormAuth(
                  isNumber: false,

                  valid: (val) {
                    return validInput(val!, 3, 30, "password");
                  },
                  mycontroller: controller.password,
                  hinttext: AppLocalizations.of(context).translate('password_hint'),
                  iconData: Icons.lock_outline,
                  labeltext: AppLocalizations.of(context).translate('password'),
                  // mycontroller: ,
                ),
                CustomButtomAuth(
                    text: AppLocalizations.of(context).translate('signup'),
                    onPressed: () {
                      if(controller.signUp()){
                        _signup(context);
                      }
                    }),
                const SizedBox(height: 40),
                CustomTextSignUpOrSignIn(
                  textone: AppLocalizations.of(context).translate('have_account'),
                  texttwo: AppLocalizations.of(context).translate('login'),
                  onTap: () {
                    controller.goToSignIn();
                  },
                ),
              ]),
            ),
          )),
    );
  }
}


class SignUpLegacy extends StatelessWidget {
  const SignUpLegacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignUpControllerImp controller = Get.put(SignUpControllerImp());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text(AppLocalizations.of(context).translate('signup'),
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: AppColor.grey)),
      ),
      body: WillPopScope(
          onWillPop: alertExitApp,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Form(
              key: controller.formstate,
              child: ListView(children: [
                const SizedBox(height: 20),
                CustomTextTitleAuth(text: AppLocalizations.of(context).translate('title')),
                const SizedBox(height: 10),
                CustomTextBodyAuth(text: AppLocalizations.of(context).translate('signup_message')),
                const SizedBox(height: 15),
                CustomTextFormAuth(
                  isNumber: false,
                  valid: (val) {
                    return validInput(val!, 3, 20, "username");
                  },
                  mycontroller: controller.username,
                  hinttext: AppLocalizations.of(context).translate('username_hint'),
                  iconData: Icons.person_outline,
                  labeltext: AppLocalizations.of(context).translate('username'),
                  // mycontroller: ,
                ),
                CustomTextFormAuth(
                  isNumber: false,

                  valid: (val) {
                    return validInput(val!, 3, 40, "email");
                  },
                  mycontroller: controller.email,
                  hinttext: AppLocalizations.of(context).translate('email_hint'),
                  iconData: Icons.email_outlined,
                  labeltext: AppLocalizations.of(context).translate('email'),
                  // mycontroller: ,
                ),
                CustomTextFormAuth(
                  isNumber: true,
                  valid: (val) {
                    return validInput(val!, 7, 11, "phone");
                  },
                  mycontroller: controller.phone,
                  hinttext: AppLocalizations.of(context).translate('phone_hint'),
                  iconData: Icons.phone_android_outlined,
                  labeltext: AppLocalizations.of(context).translate('phone'),
                  // mycontroller: ,
                ),
                CustomTextFormAuth(
                  isNumber: false,
                  valid: (val) {
                    return validInput(val!, 3, 30, "password");
                  },
                  mycontroller: controller.password,
                  hinttext: AppLocalizations.of(context).translate('password_hint'),
                  iconData: Icons.lock_outline,
                  labeltext: AppLocalizations.of(context).translate('password'),
                  // mycontroller: ,
                ),
                CustomButtomAuth(
                    text: AppLocalizations.of(context).translate('signup'),
                    onPressed: () {
                      if(controller.signUp()){

                      }
                    }),
                const SizedBox(height: 40),
                CustomTextSignUpOrSignIn(
                  textone: AppLocalizations.of(context).translate('have_account'),
                  texttwo: AppLocalizations.of(context).translate('login'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.login);
                  },
                ),
              ]),
            ),
          )),
    );
  }
}



