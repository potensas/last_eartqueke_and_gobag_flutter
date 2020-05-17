class BagItem {
  Map<dynamic, dynamic> title;
  String expiredDate;
  bool hasExpired;
  bool isBuy;
  int itemCount;

  BagItem(
      {this.title,
      this.expiredDate,
      this.hasExpired,
      this.isBuy,
      this.itemCount});
}
