// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _kk = {
  "title": "Менің Flutter қолданбам",
  "fullName": "Толық аты-жөні *",
  "phoneNumber": "Телефон нөмірі *",
  "emailAddress": "Электрондық пошта",
  "lifeStory": "Өмір тарихы",
  "password": "Құпиясөз *",
  "confirmPassword": "Құпиясөзді растаңыз *",
  "submit": "Жіберу"
};
static const Map<String,dynamic> _ru = {
  "title": "Моё Flutter приложение",
  "fullName": "Полное имя *",
  "phoneNumber": "Номер телефона *",
  "emailAddress": "Адрес электронной почты",
  "lifeStory": "История жизни",
  "password": "Пароль *",
  "confirmPassword": "Подтвердите пароль *",
  "submit": "Отправить"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"kk": _kk, "ru": _ru};
}
