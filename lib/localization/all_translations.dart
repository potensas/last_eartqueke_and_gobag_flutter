import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:last_earthquake_flutter/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class GlobalTranslations {
  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;

  Iterable<Locale> supportedLocales() => supportedLanguages.keys;

  String text(String key) {
    return (_localizedValues == null || _localizedValues[key] == null)
        ? '** $key not found'
        : _localizedValues[key];
  }

  get currentLanguage => _locale == null ? '' : _locale.languageCode;

  get locale => _locale;

  Future<Null> init([String language]) async {
    if (_locale == null) {
      await setNewLanguage(language, true, true);
    }
    return null;
  }

  getPreferredLanguage() async {
    return _getApplicationSavedInformation();
  }

  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation(lang);
  }

  Future<Null> setNewLanguage(
      [String newLanguage,
      bool saveInPrefs = false,
      bool isFirstLaunch = false]) async {
    String language = newLanguage;

    var prefLanguage = await getPreferredLanguage();

    if (isFirstLaunch && prefLanguage == '') {
      language = newLanguage;
    } else if (prefLanguage != '' && isFirstLaunch)
      language = prefLanguage;
    else if (language == "") {
      language = "en";
    }
    _locale = Locale(language, "");

    String jsonContent =
        await rootBundle.loadString("lang/${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    if (saveInPrefs) {
      await setPreferredLanguage(language);
    }

    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback();
    }

    return null;
  }

  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  Future<String> _getApplicationSavedInformation() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(languageSharedKey) ?? '';
  }

  Future<bool> _setApplicationSavedInformation(String value) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(languageSharedKey, value);
  }

  static final GlobalTranslations _translations =
      new GlobalTranslations._internal();
  factory GlobalTranslations() {
    return _translations;
  }
  GlobalTranslations._internal();
}

GlobalTranslations allTranslations = new GlobalTranslations();
