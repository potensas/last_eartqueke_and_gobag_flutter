import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/constants/constants.dart';
import 'package:last_earthquake_flutter/constants/locator.dart';
import 'package:last_earthquake_flutter/screens/licenses_page.dart';
import 'package:last_earthquake_flutter/providers/ThemeChanger.dart';
import 'package:last_earthquake_flutter/services/auth.dart';
import 'package:last_earthquake_flutter/services/database.dart';
import 'package:last_earthquake_flutter/widgets/generic_appbar.dart';
import 'package:provider/provider.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';

class SettingsPage extends StatefulWidget {
  static String route = '/settings-page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _dropdownValue;
  bool _darkModeValue = false;
  bool _notificationValue = true;

  Database db;

  @override
  void initState() {
    _notificationValue =
        instance<Database>().localCopy?.isNotification ?? false;

    _dropdownValue = supportedLanguages[allTranslations.locale];
    Provider.of<ThemeChanger>(context, listen: false).loadData().then((value) {
      setState(() {
        _darkModeValue = value;
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        preferredSize: Size.fromHeight(0.0),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            GenericAppbar(
              appBarTitle: allTranslations.text('settings'),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(35.0),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            allTranslations.text('language'),
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).textTheme.title.color,
                            ),
                          ),
                          DropdownButton(
                            underline: Container(height: 0),
                            onChanged: (newValue) async {
                              await allTranslations.setNewLanguage(
                                  supportedLanguages.keys
                                      .firstWhere(
                                          (key) =>
                                              supportedLanguages[key] ==
                                              newValue,
                                          orElse: () => Locale('en'))
                                      .languageCode,
                                  true);

                              setState(() {
                                _dropdownValue = newValue;
                              });
                            },
                            value: _dropdownValue ?? 'English',
                            items: supportedLanguages.values
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).textTheme.title.color,
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            allTranslations.text('darkMode'),
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).textTheme.title.color,
                            ),
                          ),
                          Switch.adaptive(
                            inactiveTrackColor: Theme.of(context).hoverColor,
                            activeColor: Theme.of(context).indicatorColor,
                            onChanged: (newValue) {
                              setState(() {
                                _darkModeValue = newValue;
                              });
                              _themeChanger.setTheme(newValue);
                            },
                            value: _darkModeValue,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            allTranslations.text('notifications'),
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).textTheme.title.color,
                            ),
                          ),
                          Switch.adaptive(
                            inactiveTrackColor: Theme.of(context).hoverColor,
                            activeColor: Theme.of(context).indicatorColor,
                            onChanged: (newValue) {
                              // TODO: open permission alert when permission required. 
                              instance<Auth>().setupNotificationTopic(newValue);
                              instance<Database>().saveUserSettings(
                                  {'isNotification': newValue});
                              setState(() {
                                _notificationValue = newValue;
                              });
                            },
                            value: _notificationValue,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(LicensesPage.route);
                      },
                      child: Text(
                        allTranslations.text('licenses'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
