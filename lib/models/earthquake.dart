import 'dart:math';
import 'package:intl/intl.dart';
import 'package:last_earthquake_flutter/constants/constants.dart';

class Earthquake {
  double mag;
  String place;
  String date;
  Point coordinates;
  Earthquake({this.coordinates, this.date, this.mag, this.place});

  static List<Earthquake> jsonToEarthquakeList(json) {
    List<Earthquake> _quakes;
    Iterable properties = json['features'];

    _quakes = properties.map((item) => jsonToEarthquake(item)).toList();

    return _quakes;
  }

  static Earthquake jsonToEarthquake(Map<String, dynamic> json) {
    Map<String, dynamic> props = json['properties'];
    List<dynamic> coords = json['geometry']['coordinates'];

    return Earthquake(
        coordinates: Point(coords[1], coords[0]),
        mag: props['mag'] is int
            ? double.parse(props['mag'].toString())
            : props['mag'],
        date: DateFormat(dateFormat)
            .format(DateTime.fromMillisecondsSinceEpoch(props['time'])),
        place: props['place']);
  }
}
