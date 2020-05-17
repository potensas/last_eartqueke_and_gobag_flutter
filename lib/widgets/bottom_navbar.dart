import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_earthquake_flutter/screens/firstaitkit_screen.dart';
import 'package:last_earthquake_flutter/screens/home_page.dart';
import 'package:last_earthquake_flutter/screens/settings_page.dart';

import 'package:last_earthquake_flutter/localization/all_translations.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentTab = 0;
  Widget currentPage = HomePage();
  List<Widget> pages = [
    HomePage(),
    FirstAidKit(),
    SettingsPage(),
  ];
  _onLocaleChanged() async {
    print('Language has been changed to: ${allTranslations.currentLanguage}');
    setState(() {
      pages = [
        HomePage(),
        FirstAidKit(),
        SettingsPage(),
      ];
    });
  }

  @override
  void initState() {
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: pages,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          'assets/firstaidkit.svg',
                          color: Colors.white,
                          height: 25,
                        ),
                      ),
                      Text(
                        allTranslations.text('firstAidKit'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      currentTab = 1;
                      currentPage = pages[1];
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        allTranslations.text('settings'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      currentTab = 2;
                      currentPage = pages[2];
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          splashColor: Color.fromRGBO(0, 0, 0, 0),
          onPressed: () {
            setState(() {
              currentTab = 0;
              currentPage = pages[0];
            });
          },
          backgroundColor: Theme.of(context).indicatorColor,
          child: Image.asset('assets/logo.png')),
    );
  }
}
