import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_earthquake_flutter/constants/locator.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';
import 'package:last_earthquake_flutter/models/bag_item.dart';
import 'package:last_earthquake_flutter/models/user_settings.dart';
import 'package:last_earthquake_flutter/screens/addbagitem_screen.dart';
import 'package:last_earthquake_flutter/services/database.dart';
import 'package:last_earthquake_flutter/widgets/bag_items.dart';
import 'package:last_earthquake_flutter/widgets/generic_appbar.dart';
import 'package:last_earthquake_flutter/widgets/loading.dart';

class FirstAidKit extends StatelessWidget {
  static final String route = '/first-aid-kit-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
            GenericAppbar(
              appBarTitle: allTranslations.text('firstAidKit'),
              actions: <Widget>[
                IconButton(
                  iconSize: 35,
                  color: Colors.white,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddBagItem.route);
                  },
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                    stream: instance<Database>().userSettingsStream,
                    builder: (ctx, AsyncSnapshot<UserSettings> snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting)
                        return Loading();
                      else {
                        //if(snapShot.hasError)

                        List<BagItem> items = snapShot.data?.bagItems;
                        if (items == null || items.length == 0)
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/bagitemsempty.svg',
                                  width: 65,
                                  color: Theme.of(context).hoverColor,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  allTranslations.text('emptyGoBag'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).hoverColor),
                                )
                              ],
                            ),
                          );
                        return BagItemList(items);
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
