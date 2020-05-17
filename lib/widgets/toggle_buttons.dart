import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/constants/constants.dart';
import 'package:last_earthquake_flutter/providers/filter_provider.dart';
import 'package:last_earthquake_flutter/providers/scroll_controller_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepremToggleButtons extends StatefulWidget {
  final parentPadding;
  DepremToggleButtons({@required this.parentPadding});

  @override
  _DepremToggleButtonsState createState() => _DepremToggleButtonsState();
}

class _DepremToggleButtonsState extends State<DepremToggleButtons> {
  List<bool> _selections;
  int _selectedIndex;
  FilterProvider _filterProvider;

  void _saveUserTogglePreference(int selectedIndex) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt(userToggleSharedPreferencesKey, selectedIndex);
  }

  void _getUserTogglePreference() async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.containsKey(userToggleSharedPreferencesKey)) {
      _selectedIndex =
          _sharedPreferences.getInt(userToggleSharedPreferencesKey);
      setState(() {
        _selections = List.generate(3, (index) {
          if (index == _selectedIndex)
            return true;
          else
            return false;
        });
        _filterListByMag(_selectedIndex);
      });
    }
  }

  void _filterListByMag(int index) {
    _filterProvider.setMinMag(
        index == 0 ? 2.0 : index == 1 ? 4.0 : index == 2 ? 5.0 : 2.0);
    Provider.of<ScrollControllerProvider>(context, listen: false).scrollToTop();
  }

  @override
  void initState() {
    _filterProvider = Provider.of<FilterProvider>(context, listen: false);
    _getUserTogglePreference();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _totalAvailableWidth =
        MediaQuery.of(context).size.width - 2 * widget.parentPadding;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ToggleButtons(
          constraints:
              BoxConstraints(minWidth: _totalAvailableWidth / 3, minHeight: 42),
          onPressed: (selectedIndex) {
            setState(() {
              _selections = List.generate(3, (index) {
                if (index == selectedIndex)
                  return true;
                else
                  return false;
              });
            });
            _filterListByMag(selectedIndex);
            _saveUserTogglePreference(selectedIndex);
          },
          isSelected: _selections ?? [true, false, false],
          fillColor: Theme.of(context).focusColor,
          selectedColor: Theme.of(context).canvasColor,
          color: Theme.of(context).textTheme.title.color,
          renderBorder: false,
          children: <Widget>[
            Text(
              '2+',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '4+',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '5+',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
