import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:last_earthquake_flutter/constants/constants.dart';
import 'package:last_earthquake_flutter/constants/locator.dart';
import 'package:last_earthquake_flutter/localization/all_translations.dart';
import 'package:last_earthquake_flutter/models/bag_item.dart';
import 'package:last_earthquake_flutter/services/database.dart';

class BagItemList extends StatelessWidget {
  final List<BagItem> bagItems;
  BagItemList(this.bagItems);

  Future<void> updateItems(int index, [bool delete = false]) async {
    if (delete) {
      bagItems.removeAt(index);
    } else {
      var item = bagItems.elementAt(index);
      item.isBuy = !item.isBuy;
      bagItems[index] = item;
    }
    return await instance<Database>().updateIsBuy(bagItems);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: bagItems.length,
        itemBuilder: (ctx, index) {
          return BagItemListElement(
            key: UniqueKey(),
            bagItem: bagItems[index],
            index: index,
            updateItemsFunc: updateItems,
          );
        });
  }
}

class BagItemListElement extends StatefulWidget {
  const BagItemListElement({
    Key key,
    this.updateItemsFunc,
    this.index,
    @required this.bagItem,
  }) : super(key: key);

  final BagItem bagItem;
  final Function updateItemsFunc;
  final int index;
  @override
  _BagItemListElementState createState() => _BagItemListElementState();
}

class _BagItemListElementState extends State<BagItemListElement> {
  bool _checkBoxInitValue;
  Color _dateColor = Colors.red;
  bool hasExpired;
  @override
  void initState() {
    _checkBoxInitValue = widget.bagItem.isBuy ?? false;
    hasExpired = widget.bagItem.hasExpired ?? false;
    if (hasExpired) {
      try {
        var _parsedDate = DateFormat(datePickerButtonsDateFormat)
            .parse(widget.bagItem.expiredDate ?? "");
        _dateColor =
        _parsedDate.isAfter(DateTime.now()) ? Colors.green : Colors.red;
      } catch (e) {
        _dateColor = Colors.grey;
      }

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (val) {
        widget.updateItemsFunc(widget.index, true);
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(
            activeColor: Theme.of(context).primaryColor,
            value: _checkBoxInitValue,
            onChanged: (val) {
              widget.updateItemsFunc(widget.index);
              setState(() {
                _checkBoxInitValue = val;
              });
            },
          ),
          title: Text(
            widget
                .bagItem.title[(allTranslations.locale as Locale).languageCode],
            style: Theme.of(context).textTheme.title.copyWith(
                decorationColor: Colors.black,
                decorationThickness: 2,
                decoration: _checkBoxInitValue
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          trailing: hasExpired && widget.bagItem?.expiredDate != ""
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  margin: EdgeInsets.all(10),
                  width: 100,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: _dateColor,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        widget.bagItem.expiredDate,
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: _dateColor,
                            ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
