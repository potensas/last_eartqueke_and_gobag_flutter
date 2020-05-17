import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';

import 'package:last_earthquake_flutter/providers/filter_provider.dart';
import 'package:last_earthquake_flutter/widgets/date_buttons.dart';

import 'package:last_earthquake_flutter/widgets/toggle_buttons.dart';

import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  var isOpen = false;
  TextEditingController _textFieldController;
  final _mainContainerHorizontalPadding = 20.0;
  final _mainContainerVerticalPadding = 10.0;
  var isSearchVisible = false;
  FilterProvider _filterProvider;
  var _focusNode = FocusNode();

  AnimationController _controller;

  Animation _scaleAnimation;
  double _getTheCorrectHeight() {
    if (!isOpen)
      return 75;
    else if (isOpen && isSearchVisible)
      return 150;
    else
      return 200;
  }

  @override
  void initState() {
    _textFieldController = TextEditingController();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    //_opacityAnim = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _filterProvider = Provider.of<FilterProvider>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.symmetric(
          horizontal: _mainContainerHorizontalPadding,
          vertical: _mainContainerVerticalPadding),
      height: _getTheCorrectHeight(),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    allTranslations.text('latestEarthquake'),
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(_focusNode);
                        if (!isOpen) {
                          isSearchVisible = true;
                          isOpen = true;
                          _controller.forward();
                        } else if (!isSearchVisible && isOpen) {
                          isSearchVisible = true;
                        } else if (isSearchVisible && isOpen) {
                          FocusScope.of(context).unfocus();
                          isOpen = false;
                          _controller.reverse();
                        }
                      });
                    },
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        if (isSearchVisible && isOpen) {
                          isSearchVisible = false;
                        } else if (isOpen && !isSearchVisible) {
                          isOpen = false;
                          _controller.reverse();
                        } else if (!isOpen) {
                          isSearchVisible = false;
                          _controller.forward();
                          isOpen = true;
                        }
                      });
                    },
                  )
                ],
              )
            ],
          ),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              height: isOpen ? 50 : 0,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: AnimatedCrossFade(
                  crossFadeState: isSearchVisible
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 150),
                  secondChild: Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _textFieldController,
                      focusNode: _focusNode,
                      onChanged: (val) {
                        _filterProvider.setSearchText(val);
                      },
                      style: TextStyle(
                          color: Theme.of(context).textTheme.title.color),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback(
                                (_) => _textFieldController.clear());
                            _filterProvider.setSearchText('');
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).textTheme.title.color,
                          ),
                        ),
                        hintText:
                            allTranslations.text('enterEarthquakeLocation'),
                        hintStyle:
                            TextStyle(color: Theme.of(context).hoverColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fillColor: Theme.of(context).canvasColor,
                        //labelText: 'Enter earthquake location',
                      ),
                    ),
                  ),
                  firstChild: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        DateButtons(
                          parentPadding: _mainContainerHorizontalPadding,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DepremToggleButtons(
                          parentPadding: _mainContainerHorizontalPadding,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
