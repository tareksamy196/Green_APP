// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:cantu/controller/auth/login_controller.dart';
import 'package:cantu/core/constant/color.dart';
import 'package:cantu/core/constant/routes.dart';
import 'package:cantu/core/functions/alertexitapp.dart';
import 'package:cantu/core/functions/validinput.dart';
import 'package:cantu/core/widget/auth/custombuttonauth.dart';
import 'package:cantu/core/widget/auth/customtextbodyauth.dart';
import 'package:cantu/core/widget/auth/customtextformauth.dart';
import 'package:cantu/core/widget/auth/customtexttitleauth.dart';
import 'package:cantu/core/widget/auth/logoauth.dart';
import 'package:cantu/core/widget/auth/textsignup.dart';
import 'package:cantu/data/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../I18n.dart';
import '../../data/model/profileModel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var api = ApiService();
  LoginControllerImp controller = Get.put(LoginControllerImp());
  Future<void> _login(BuildContext context) async {
    api.login(controller.email.text, controller.password.text).then((success) {
      if (success) {
        Navigator.pushNamed(context, AppRoute.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade50,
        elevation: 0.0,
        title: Text(AppLocalizations.of(context).translate('login'),
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
                const LogoAuth(),
                const SizedBox(height: 20),
                CustomTextTitleAuth(text: AppLocalizations.of(context).translate('welcome')),
                const SizedBox(height: 10),
                CustomTextBodyAuth(text: AppLocalizations.of(context).translate('sign_in_message')),
                const SizedBox(height: 15),
                CustomTextFormAuth(
                  isNumber: false,

                  valid: (val) {
                    return validInput(val!, 5, 100, "email");
                  },
                  mycontroller: controller.email,
                  hinttext: AppLocalizations.of(context).translate('email_hint'),
                  iconData: Icons.email_outlined,
                  labeltext: AppLocalizations.of(context).translate('email'),
                ),
                GetBuilder<LoginControllerImp>(
                  builder: (controller) => CustomTextFormAuth(
                    obscureText: controller.isshowpassword,
                    onTapIcon: () {
                      controller.showPassword();
                    },
                    isNumber: false,
                    valid: (val) {
                      return validInput(val!, 5, 30, "password");
                    },
                    mycontroller: controller.password,
                    hinttext: AppLocalizations.of(context).translate('password_hint'),
                    iconData: Icons.lock_outline,
                    labeltext: AppLocalizations.of(context).translate('password'),
                    // mycontroller: ,
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.goToForgetPassword();
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('forget_password'),
                    textAlign: TextAlign.right,
                  ),
                ),
                CustomButtomAuth(
                    text: AppLocalizations.of(context).translate('login'),
                    onPressed: () {
                      if(controller.login()){
                        _login(context);
                      }
                    }),
                const SizedBox(height: 40),
                CustomTextSignUpOrSignIn(
                  textone: AppLocalizations.of(context).translate('no_account'),
                  texttwo: AppLocalizations.of(context).translate('signup'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.signUp);
                  },
                )
              ]),
            ),
          )),
    );
  }

}


class LoginLegacy extends StatelessWidget {
  const LoginLegacy({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    LoginControllerImp controller = Get.put(LoginControllerImp());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text(AppLocalizations.of(context).translate('login'),
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
                const LogoAuth(),
                const SizedBox(height: 20),
                CustomTextTitleAuth(text: AppLocalizations.of(context).translate('welcome')),
                const SizedBox(height: 10),
                CustomTextBodyAuth(text: AppLocalizations.of(context).translate('sign_in_message')),
                const SizedBox(height: 15),
                CustomTextFormAuth(
                  isNumber: false,

                  valid: (val) {
                    return validInput(val!, 5, 100, "email");
                  },
                  mycontroller: controller.email,
                  hinttext: AppLocalizations.of(context).translate('email_hint'),
                  iconData: Icons.email_outlined,
                  labeltext: AppLocalizations.of(context).translate('email'),
                ),
                GetBuilder<LoginControllerImp>(
                  builder: (controller) => CustomTextFormAuth(
                    obscureText: controller.isshowpassword,
                    onTapIcon: () {
                      controller.showPassword();
                    },
                    isNumber: false,
                    valid: (val) {
                      return validInput(val!, 5, 30, "password");
                    },
                    mycontroller: controller.password,
                    hinttext: AppLocalizations.of(context).translate('password_hint'),
                    iconData: Icons.lock_outline,
                    labeltext: AppLocalizations.of(context).translate('password'),
                    // mycontroller: ,
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.goToForgetPassword();
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('forget_password'),
                    textAlign: TextAlign.right,
                  ),
                ),
                CustomButtomAuth(
                    text: AppLocalizations.of(context).translate('login'),
                    onPressed: () {
                      if(controller.login()){

                      }
                    }),
                const SizedBox(height: 40),
                CustomTextSignUpOrSignIn(
                  textone: AppLocalizations.of(context).translate('no_account'),
                  texttwo: AppLocalizations.of(context).translate('signup'),
                  onTap: () {
                    controller.goToSignUp();
                  },
                )
              ]),
            ),
          )),
    );
  }
}
