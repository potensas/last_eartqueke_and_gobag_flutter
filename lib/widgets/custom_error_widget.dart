import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final Function refreshFunc;
  CustomErrorWidget({this.errorMessage, this.refreshFunc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            size: 65,
            color: Theme.of(context).errorColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            errorMessage,
            style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 16),
          ),
          if (refreshFunc != null)
            FlatButton(
              child: Text(
                'Refresh',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Theme.of(context).accentColor),
              ),
              onPressed: refreshFunc,
            )
        ],
      ),
    );
  }
}
