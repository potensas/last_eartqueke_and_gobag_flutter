import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:last_earthquake_flutter/constants/constants.dart';
import 'package:last_earthquake_flutter/constants/locator.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';
import 'package:last_earthquake_flutter/services/database.dart';
import 'package:last_earthquake_flutter/widgets/generic_appbar.dart';

class AddBagItem extends StatefulWidget {
  static final String route = '/add-new-item-page';

  @override
  _AddBagItemState createState() => _AddBagItemState();
}

class _AddBagItemState extends State<AddBagItem>
    with SingleTickerProviderStateMixin {
  bool _isAddingLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey();
  AnimationController _controller;
  Animation _opacityAnimation;
  FocusNode _btnFocus;
  var formData;

  @override
  void initState() {
    _btnFocus = FocusNode();
    formData = {
      'itemCount': 1,
      'isBuy': false,
      'title': {},
      'hasExpired': false,
      'expiredDate': DateFormat('dd/MM/yyyy')
          .format(DateTime.now().add(Duration(days: 365)))
    };
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

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
      body: Column(
        children: <Widget>[
          GenericAppbar(
            backButton: true,
            appBarTitle: allTranslations.text('addBagItem'),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).requestFocus(_btnFocus);
                        },
                        autofocus: false,
                        onSaved: (val) {
                          formData['title']['en'] = val;

                          formData['title']['tr'] = val;
                        },
                        validator: (val) {
                          if (val == "")
                            return allTranslations.text('NameCanNotBeEmpty');
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          hintText: allTranslations.text('bagItemName'),
                          hintStyle: TextStyle(color: Color(0xff696969)),
                          border: InputBorder.none,
                          fillColor: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          allTranslations.text('hasExpiryDate'),
                          style: Theme.of(context).textTheme.title,
                        ),
                        Switch.adaptive(
                            inactiveTrackColor: Theme.of(context).hoverColor,
                            activeColor: Theme.of(context).indicatorColor,
                            value: formData['hasExpired'],
                            onChanged: (val) {
                              setState(() {
                                formData['hasExpired'] = val;
                                if (val)
                                  _controller.forward();
                                else
                                  _controller.reverse();
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      constraints: BoxConstraints(
                          minHeight: formData['hasExpired'] ? 50 : 0,
                          maxHeight: formData['hasExpired'] ? 100 : 0),
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Container(
                          height: 65,
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.calendar_today),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1, 1, 1990),
                                            lastDate: DateTime.now()
                                                .add(Duration(days: 10 * 365)))
                                        .then((val) {
                                      if (val != null) {
                                        formData['expiredDate'] = DateFormat(
                                                datePickerButtonsDateFormat)
                                            .format(val);
                                      }
                                    });
                                  },
                                  child: Text(
                                    formData['expiredDate'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(
                                            fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                        focusNode: _btnFocus,
                        color: Theme.of(context).primaryColor,
                        child: _isAddingLoading
                            ? SizedBox(
                                width: 50,
                                height: 30,
                                child: SpinKitPulse(
                                  color: Colors.white,
                                  size: 50,
                                ),
                              )
                            : Text(
                                allTranslations.text('add'),
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(
                                        fontSize: 16, color: Colors.white),
                              ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (!formData['hasExpired']) {
                              formData['expiredDate'] = "";
                            }
                            setState(() {
                              _isAddingLoading = true;
                            });
                            await instance<Database>()
                                .updateUserBagItms(formData);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
