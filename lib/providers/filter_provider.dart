import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  double mag = 2;
  String search = '';
  bool isLoading = false;
  void setMinMag(minMag) {
    mag = minMag;
    notifyListeners();
  }

  void setSearchText(txt) {
    search = txt;
    notifyListeners();
  }

  void setLoading(bool loading) {
    this.isLoading = loading;
    notifyListeners();
  }

  bool get loading => isLoading;

  double get minMag => mag;
  String get searchText => search;
}
