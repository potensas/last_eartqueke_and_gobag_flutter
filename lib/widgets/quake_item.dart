import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/constants/constants.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';

import 'package:last_earthquake_flutter/providers/earhquake_provider.dart';
import 'package:last_earthquake_flutter/providers/filter_provider.dart';
import 'package:last_earthquake_flutter/screens/detail_page.dart';
import 'package:last_earthquake_flutter/providers/scroll_controller_provider.dart';
import 'package:last_earthquake_flutter/widgets/custom_error_widget.dart';
import 'package:provider/provider.dart';
import 'package:last_earthquake_flutter/constants/colors.dart';

import 'loading.dart';

class QuakeItem extends StatefulWidget {
  @override
  _QuakeItemState createState() => _QuakeItemState();
}

class _QuakeItemState extends State<QuakeItem> {
  ScrollController _scrollController;

  Color getColorfromMag(mag) {
    if (mag >= 8)
      return mag8;
    else if (mag >= 6)
      return mag6;
    else if (mag >= 4)
      return mag4;
    else
      return magElse;
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ScrollControllerProvider>(context)
        .setScrollController(_scrollController);
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<FilterProvider>(context, listen: false).setLoading(true);
        await Provider.of<EarthquakeProvider>(context, listen: false)
            .fetchEarhquakes();
        Provider.of<FilterProvider>(context, listen: false).setLoading(false);
      },
      child: Consumer<FilterProvider>(
        builder: (ctx, filter, child) {
          if (filter.isLoading) return Loading();
          var _quakes = Provider.of<EarthquakeProvider>(context)
              .getEarthQuakes(filter.minMag, filter.searchText);
          if (_quakes.length == 0) {
            return CustomErrorWidget(
              errorMessage: allTranslations.text('noDataFound'),
            );
          } else
            return ListView.builder(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              key: PageStorageKey<String>(listViewKey),
              itemCount: _quakes.length,
              itemBuilder: (ctx, index) {
                var quake = _quakes[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(DetailPage.route, arguments: quake);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).backgroundColor,
                            blurRadius: 5,
                            offset: Offset(2, 5),
                          )
                        ]),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            quake.mag.toStringAsFixed(1),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.title.copyWith(
                                  color: getColorfromMag(quake.mag),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        title: Text(
                          quake.place,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).textTheme.title.color),
                        ),
                        subtitle: Text(
                          quake.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.display2.color,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          color: Theme.of(context).textTheme.display2.color,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(DetailPage.route, arguments: quake);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
        },
      ),
    );
  }
}
