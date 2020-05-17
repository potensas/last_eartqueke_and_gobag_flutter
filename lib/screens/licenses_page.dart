import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/constants/licenses.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';

class LicensesPage extends StatelessWidget {
  static String route = '/licenses-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        preferredSize: Size.fromHeight(0.0),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 75,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    allTranslations.text('licenses'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(35.0),
                    child: Text(
                      licenses,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.title.color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
