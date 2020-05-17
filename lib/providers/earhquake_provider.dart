import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:last_earthquake_flutter/models/earthquake.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EarthquakeProvider extends ChangeNotifier {
  List<Earthquake> _quakes = [];
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now().subtract(Duration(days: 30));

  //test url
  // var tempUrl =
  //     'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2014-01-01&endtime=2014-02-02&limit=5';

  Future<bool> fetchEarhquakes() async {
    //if (_quakes.length > 0) return true;
    var startDateString = DateFormat('yyyy-MM-dd').format(startDate);
    var endDateString = DateFormat('yyyy-MM-dd').format(endDate);

    var queryParameters = {
      'format': 'geojson',
      'starttime': startDateString,
      'endtime': endDateString,
      'limit': '1000'
    };
    var uri = Uri.https(
        'earthquake.usgs.gov', '/fdsnws/event/1/query', queryParameters);

    try {
      var response = await http.get(uri);
      _quakes = Earthquake.jsonToEarthquakeList(json.decode(response.body));
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Earthquake> filterByMag(double minMag) {
    return [
      ..._quakes.where((item) {
        return item.mag >= minMag;
      }).toList()
    ];
  }

  DateTime get getStartDate => startDate;
  DateTime get getEndDate => endDate;

  List<Earthquake> getEarthQuakes(minMag, searchTxt) {
    return [
      ..._quakes.where((item) {
        if (searchTxt == '')
          return ((item.mag ?? 0) >= minMag);
        else
          return ((item.mag ?? 0) >= minMag &&
              item.place.toLowerCase().contains(searchTxt.toLowerCase()));
      }).toList()
    ];
  }

  Future<void> setStartDate(DateTime startDateValue) async {
    startDate = startDateValue;
    await fetchEarhquakes();
    notifyListeners();
  }

  Future<void> setEndDate(DateTime endDateValue) async {
    endDate = endDateValue;
    await fetchEarhquakes();
    notifyListeners();
  }
}
