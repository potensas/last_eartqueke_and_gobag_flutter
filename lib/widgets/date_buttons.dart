import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:last_earthquake_flutter/constants/constants.dart';
import 'package:last_earthquake_flutter/providers/earhquake_provider.dart';
import 'package:last_earthquake_flutter/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class DateButtons extends StatefulWidget {
  final parentPadding;
  DateButtons({@required this.parentPadding});

  @override
  _DateButtonsState createState() => _DateButtonsState();
}

class _DateButtonsState extends State<DateButtons> {
  EarthquakeProvider _quakeProvider;
  FilterProvider _filterProvider;
  void _showEndDatePicker(ctx) {
    showDatePicker(
            context: ctx,
            initialDate: _quakeProvider.getEndDate,
            lastDate: DateTime.now(),
            firstDate: _quakeProvider.getStartDate)
        .then((value) async {
      if (value != null) {
        _filterProvider.setLoading(true);
        await _quakeProvider.setEndDate(value);
        _filterProvider.setLoading(false);
      }
    });
  }

  void _showStartDatePicker(ctx) {
    showDatePicker(
            context: ctx,
            initialDate: _quakeProvider.getStartDate,
            lastDate: DateTime.now(),
            firstDate: DateTime(1990))
        .then((value) async {
      if (value != null) {
        _filterProvider.setLoading(true);
        await _quakeProvider.setStartDate(value);
        _filterProvider.setLoading(false);
      }
    });
  }

  @override
  void initState() {
    _quakeProvider = Provider.of<EarthquakeProvider>(context, listen: false);
    _filterProvider = Provider.of<FilterProvider>(context, listen: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var _totalAvailableWith =
        MediaQuery.of(context).size.width - 2 * widget.parentPadding;

    var _quakeProvider = Provider.of<EarthquakeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: _totalAvailableWith / 2,
          height: 42,
          child: RaisedButton(
            child: Text(
              DateFormat(datePickerButtonsDateFormat)
                  .format(_quakeProvider.getStartDate),
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            color: Theme.of(context).canvasColor,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            onPressed: () {
              _showStartDatePicker(context);
            },
          ),
        ),
        SizedBox(
          width: _totalAvailableWith / 2,
          height: 42,
          child: RaisedButton(
            child: Text(
              DateFormat(datePickerButtonsDateFormat)
                  .format(_quakeProvider.getEndDate),
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            color: Theme.of(context).canvasColor,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30))),
            onPressed: () {
              _showEndDatePicker(context);
            },
          ),
        ),
      ],
    );
  }
}
