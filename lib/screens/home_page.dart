import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';

import 'package:last_earthquake_flutter/providers/earhquake_provider.dart';
import 'package:last_earthquake_flutter/providers/scroll_controller_provider.dart';
import 'package:last_earthquake_flutter/widgets/custom_error_widget.dart';

import 'package:last_earthquake_flutter/widgets/loading.dart';
import 'package:last_earthquake_flutter/widgets/my_app_bar.dart';
import 'package:last_earthquake_flutter/widgets/quake_item.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String route = '/home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var _fetchStatus = FetchStatus.idle;
  var _isIinit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isIinit) {
      setState(() {
        _fetchStatus = FetchStatus.loading;
      });
      Provider.of<EarthquakeProvider>(context).fetchEarhquakes().then((val) {
        setState(() {
          val
              ? _fetchStatus = FetchStatus.done
              : _fetchStatus = FetchStatus.error;
        });
      });
      _isIinit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (ctx) => ScrollControllerProvider(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
            ),
            preferredSize: Size.fromHeight(0.0)),
        body: Column(
          children: <Widget>[
            MyAppBar(),
            Expanded(
              child: _fetchStatus == FetchStatus.loading
                  ? Loading()
                  : _fetchStatus == FetchStatus.done
                      ? QuakeItem()
                      : CustomErrorWidget(
                          errorMessage:
                              allTranslations.text('couldNotLoadData'),
                        ),
            )
          ],
        ),
      ),
    );
  }
}

enum FetchStatus {
  loading,
  idle,
  done,
  error,
}
