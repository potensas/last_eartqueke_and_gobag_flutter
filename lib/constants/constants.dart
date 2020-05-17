import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<int, Color> primarySwtach = {
  50: Color.fromRGBO(228, 44, 44, .1),
  100: Color.fromRGBO(228, 44, 44, .2),
  200: Color.fromRGBO(228, 44, 44, .3),
  300: Color.fromRGBO(228, 44, 44, .4),
  400: Color.fromRGBO(228, 44, 44, .5),
  500: Color.fromRGBO(228, 44, 44, .6),
  600: Color.fromRGBO(228, 44, 44, .7),
  700: Color.fromRGBO(228, 44, 44, .8),
  800: Color.fromRGBO(228, 44, 44, .9),
  900: Color.fromRGBO(228, 44, 44, 1),
};
String userToggleSharedPreferencesKey = 'userToggleKey';
String dateFormat = 'dd/MM/yyyy hh:mm';
String datePickerButtonsDateFormat = 'dd/MM/yyyy';
String listViewKey = 'listViewKey';
String languageSharedKey = 'ApplicationLanguageKey';
Map<Locale, String> supportedLanguages = {
  Locale('en', ''): 'English',
  Locale('tr', ''): 'Türkçe'
};
