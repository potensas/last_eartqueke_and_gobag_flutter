import 'package:last_earthquake_flutter/models/bag_item.dart';

class UserSettings {
  List<BagItem> bagItems;
  bool isDarkMode;
  bool isNotification;
  String lastLoginDate;
  String prefLang;

  UserSettings(
      {this.bagItems,
      this.isDarkMode,
      this.isNotification,
      this.lastLoginDate,
      this.prefLang});
}
