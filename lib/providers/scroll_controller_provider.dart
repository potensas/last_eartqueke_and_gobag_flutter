import 'package:flutter/material.dart';

class ScrollControllerProvider {
  ScrollController _scrollController;

  void setScrollController(ScrollController _ctrl) {
    _scrollController = _ctrl;
  }

  void scrollToTop() {
    if (_scrollController != null)
      _scrollController.animateTo(0.0,
          curve: Curves.easeInOut, duration: Duration(milliseconds: 500));
  }
}
