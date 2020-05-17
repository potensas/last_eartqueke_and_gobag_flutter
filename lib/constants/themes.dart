import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Color(0xffE42C2C), // kırmızı -> koyu gri
  backgroundColor: Color(0xffEAEAEA), // acik gri -> siyah
  cardColor: Color(0xffFFFFFF), // beyaz -> koyu gri
  focusColor: Color(0xffBBBBBB), // gri ->kırmızı
  highlightColor: Color(0xffBBBBBB), // gri -> siyah
  canvasColor: Color(0xffFFFFFF),
  // beyaz -> siyah
  hoverColor: Color(0xff353535),
  indicatorColor: Color(0xffE42C2C), // kırmızı -> kırmızı
  textTheme: TextTheme(
    title: TextStyle(
      color: Color(0xff000000), // siyah -> beyaz
    ),
    display1: TextStyle(
      color: Color(0xffFFFFFF), // beyaz -> beyaz
    ),
    display2: TextStyle(
      color: Color(0xffBBBBBB), // gri -> gri
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Color(0xff353535),
  backgroundColor: Color(0xff000000),
  cardColor: Color(0xff353535),
  focusColor: Color(0xffE42C2C),
  highlightColor: Color(0xff000000),
  canvasColor: Color(0xff000000),
  indicatorColor: Color(0xffE42C2C),
  hoverColor: Color(0xffbbbbbb),
  textTheme: TextTheme(
    title: TextStyle(
      color: Color(0xffFFFFFF),
    ),
    display1: TextStyle(
      color: Color(0xffFFFFFF),
    ),
    display2: TextStyle(
      color: Color(0xffBBBBBB),
    ),
  ),
);
