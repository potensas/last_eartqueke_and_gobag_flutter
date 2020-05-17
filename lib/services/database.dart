import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last_earthquake_flutter/models/bag_item.dart';
import 'package:last_earthquake_flutter/models/user_settings.dart';

class Database {
  String userId;
  UserSettings localCopy;
  Database({this.userId}) {
    print(userId);
  }

  var usersRef = Firestore.instance.collection('users');
  var firstAidRef = Firestore.instance.collection('firstaids');
  UserSettings get getLocalCopy => localCopy;
  Stream<UserSettings> get userSettingsStream {
    return usersRef.document(userId).snapshots().map(convertToUserSettingModel);
  }

  Future<UserSettings> getUserSettingsFuture() async {
    var snap = await usersRef.document(userId).get();

    if (snap.data == null) {
      var defaultBagQuery = await Firestore.instance
          .collection('initalbagitems')
          .document('default')
          .get();
      var defaultBagItems = convertToBagItem(defaultBagQuery);

      var settings = {
        "prefLang": "tr",
        "isNotification": true,
        "isDarkMode": false,
        "lastLoginDate": "",
        "bagItems": defaultBagItems ?? []
      };
      await usersRef.document(userId).setData(settings, merge: true);
      var userSettings = convertToUserSettingModelFromMap(settings);
      return userSettings;
    } else {
      var userSettings = convertToUserSettingModel(snap);
      return userSettings;
    }
  }

  Future<void> saveUserSettings(data) async {
    if (data == null) return;
    return await usersRef.document(userId).updateData(data);
  }

  Future<void> updateIsBuy(List<BagItem> items) async {
    List<Map<String, dynamic>> listMap = [];
    listMap = items
        .map((item) => {
              'title': item.title,
              'hasExpired': item.hasExpired,
              'expiredDate': item.expiredDate,
              'isBuy': item.isBuy,
              'itemCount': item.itemCount,
            })
        .toList();
    return await usersRef.document(userId).updateData({'bagItems': listMap});
  }

  Future<void> updateUserBagItms(data) async {
    return await usersRef.document(userId).updateData({
      'bagItems': FieldValue.arrayUnion([data])
    });
  }

  UserSettings convertToUserSettingModel(DocumentSnapshot snap) {
    return convertToUserSettingModelFromMap(snap.data);
  }

  UserSettings convertToUserSettingModelFromMap(Map<String, dynamic> data) {
    var bags = data == null ? new List() : data['bagItems'] as List<dynamic>;

    var userSettings = UserSettings(
        isDarkMode: data['isDarkMode'],
        isNotification: data['isNotification'],
        lastLoginDate: data['lastLoginDate'],
        prefLang: data['prefLang'],
        bagItems: getBagList(bags));
    localCopy = userSettings;
    return userSettings;
  }

  // UserSettings convertToUserSettingModel(DocumentSnapshot snap) {
  //   var data = snap.data;

  //   var bags = (data == null) ? new List() : (data['bagItems'] as List<dynamic>);

  //   var userSettings = data == null ?
  //       UserSettings(
  //           isDarkMode: false,
  //           isNotification: false,
  //           lastLoginDate: "",
  //           prefLang:  "en",
  //           bagItems: [])
  //       : UserSettings(
  //           isDarkMode: data['isDarkMode'] ?? false,
  //           isNotification: data['isNotification'] ?? false,
  //           lastLoginDate: data['lastLoginDate'] ?? "",
  //           prefLang: data['prefLang'] ?? "en",
  //           bagItems: getBagList(bags));
  //   localCopy = userSettings;
  //   return userSettings;
  // }

  List<Map<String, dynamic>> convertToBagItem(DocumentSnapshot snapshot) {
    List<Map<String, dynamic>> list = [];
    List<dynamic> items = snapshot['items'];
    list = items
        .map((item) => {
              "expiredDate": item['expiredDate'],
              "hasExpired": item['hasExpired'],
              "isBuy": item['isBuy'],
              "itemCount": item['itemCount'],
              "title": item['title']
            })
        .toList();

    return list;
  }

  List<BagItem> getBagList(List<dynamic> jsonList) {
    List<BagItem> list = [];

    list = jsonList.map((item) {
      return BagItem(
          expiredDate: item['expiredDate'],
          hasExpired: item['hasExpired'],
          isBuy: item['isBuy'],
          itemCount: item['itemCount'],
          title: item['title']);
    }).toList();

    return list;
  }
}
