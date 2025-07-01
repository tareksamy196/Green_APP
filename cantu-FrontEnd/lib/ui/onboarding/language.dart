
import 'package:cantu/I18n.dart';
import 'package:cantu/core/localization/changelocal.dart';
import 'package:cantu/core/widget/language/custombuttomlang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../core/constant/routes.dart';
import '../../core/providers/LocalProvider.dart';

class Language extends GetView<LocaleController> {
  const Language({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context).translate('choose_language'), style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              CustomButtonLang(
                  textbutton: AppLocalizations.of(context).translate('language_ar'),
                  onPressed: () {
                    context.read<LocaleProvider>().setLocale('ar');
                    Navigator.pushNamed(context, AppRoute.login);
                  }),
              CustomButtonLang(
                  textbutton: AppLocalizations.of(context).translate('language_en'),
                  onPressed: () {
                    context.read<LocaleProvider>().setLocale('en');
                    Navigator.pushNamed(context, AppRoute.login);
                  }),
            ],
          )),
    );
  }
}
