import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:last_earthquake_flutter/constants/locator.dart';
import 'package:last_earthquake_flutter/providers/ThemeChanger.dart';
import 'package:last_earthquake_flutter/providers/earhquake_provider.dart';
import 'package:last_earthquake_flutter/providers/filter_provider.dart';
import 'package:last_earthquake_flutter/screens/addbagitem_screen.dart';
import 'package:last_earthquake_flutter/screens/firstaitkit_screen.dart';
import 'package:last_earthquake_flutter/screens/detail_page.dart';
import 'package:last_earthquake_flutter/screens/home_page.dart';
import 'package:last_earthquake_flutter/screens/licenses_page.dart';
import 'package:last_earthquake_flutter/services/auth.dart';
import 'package:last_earthquake_flutter/services/database.dart';
import 'package:last_earthquake_flutter/widgets/bottom_navbar.dart';
import 'package:last_earthquake_flutter/screens/settings_page.dart';
import 'package:provider/provider.dart';

import 'constants/themes.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
//  Crashlytics.instance.crash();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setupAuthInstance(context, FirebaseMessaging());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: EarthquakeProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FilterProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ThemeChanger(lightTheme),
        ),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> initUserSettings() async {
      await instance<Auth>().signIn();
      await instance<Database>().getUserSettingsFuture();
      await instance<Auth>().setupNotification();
      await allTranslations.init(ui.window.locale?.languageCode ?? "en");
      return Future.value();
    }

    initTheme() async {
      ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

      _themeChanger.loadData(true);
    }

    initTheme();

    return MaterialApp(
      title: allTranslations.text('appName'),
      theme: Provider.of<ThemeChanger>(context).getTheme(),
      home: SplashScreen.navigate(
        name: 'assets/splash_anim.flr',
        next: (context) => BottomNavbar(),
        until: () => Future.wait([initUserSettings()]),
        loopAnimation: 'splash',
        backgroundColor: Color(0xffE42C2C),
      ),
      routes: {
        HomePage.route: (ctx) => HomePage(),
        DetailPage.route: (ctx) => DetailPage(),
        SettingsPage.route: (ctx) => SettingsPage(),
        LicensesPage.route: (ctx) => LicensesPage(),
        AddBagItem.route: (ctx) => AddBagItem(),
        FirstAidKit.route: (ctx) => FirstAidKit(),
      },
      supportedLocales: allTranslations.supportedLocales(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
