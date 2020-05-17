import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';
import 'package:last_earthquake_flutter/models/earthquake.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailPage extends StatefulWidget {
  static final String route = '/detail-page';

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Completer<GoogleMapController> _controller = Completer();
  var _showGoogleMaps = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showGoogleMaps = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _quake = ModalRoute.of(context).settings.arguments as Earthquake;
    var _totalAvailableHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: _totalAvailableHeight / 1.35,
              child: _showGoogleMaps
                  ? GoogleMap(
                      markers: Set.of([
                        Marker(
                          markerId: MarkerId(_quake.place.toString()),
                          draggable: false,
                          position: LatLng(_quake.coordinates.x.toDouble(),
                              _quake.coordinates.y.toDouble()),
                        )
                      ]),
                      mapType: MapType.terrain,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_quake.coordinates.x.toDouble(),
                            _quake.coordinates.y.toDouble()),
                        zoom: 1.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    )
                  : Container(),
            ),
            SafeArea(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            )
          ],
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SolidBottomSheet(
            draggableBody: true,
            minHeight: _totalAvailableHeight / 3,
            maxHeight: _totalAvailableHeight / 3,
            headerBar: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(35),
                child: Text(
                  allTranslations.text('earthquakeDetails'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.title.color,
                  ),
                ),
              ),
            ),
            body: Container(
              color: Theme.of(context).cardColor,
              height: 500,
              child: Table(columnWidths: {
                0: FlexColumnWidth(2.0),
                1: FlexColumnWidth(3.0)
              }, children: [
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(35, 10, 0, 10),
                      child: Text(allTranslations.text('place'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.title.color,
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(0, 10, 35, 10),
                      child: Text(
                        '${_quake.place.toString()}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(35, 10, 0, 10),
                      child: Text(allTranslations.text('magnitude'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.title.color,
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(0, 10, 35, 10),
                      child: Text(
                        '${_quake.mag.toString()}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(35, 10, 0, 10),
                      child: Text(allTranslations.text('DateAndTime'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.title.color,
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(0, 10, 35, 10),
                      child: Text(
                        '${_quake.date.toString()}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ],
    ));
  }
}
