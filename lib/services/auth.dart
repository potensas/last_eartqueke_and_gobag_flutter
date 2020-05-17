import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/constants/locator.dart';
import 'package:last_earthquake_flutter/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  StreamSubscription iosSubscription;
  final FirebaseMessaging firebaseMessaging;
  final BuildContext context;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Auth({this.firebaseMessaging, this.context}) {}

  Future<void> setupNotification() async {
    if (Platform.isIOS) {
      iosSubscription =
          firebaseMessaging.onIosSettingsRegistered.listen((data) {});

      var result = await firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
      if (result == true) {
        if (instance<Database>().localCopy?.isNotification == false) {
          setupNotificationTopic(false);
        } else {
          setupNotificationTopic(true);
          await instance<Database>().saveUserSettings({"isNotification": true});
          instance<Database>().localCopy?.isNotification = true;
        }
      } else {
        setupNotificationTopic(false);
        await instance<Database>().saveUserSettings({"isNotification": false});
        instance<Database>().localCopy?.isNotification = false;
      }
    } else {
      var user = await instance<Database>().getUserSettingsFuture();
      await setupNotificationTopic(user.isNotification);
    }

    firebaseMessaging.configure(
        onMessage: processMessage,
        onLaunch: processLaunch,
        onResume: processResume);
  }

  Future<void> setupNotificationTopic(bool state) {
    if (state == true) {
      print("subscribe to general");
      firebaseMessaging.subscribeToTopic("general");
      firebaseMessaging.unsubscribeFromTopic("disable");
    } else {
      print("subscribe to disable");
      firebaseMessaging.subscribeToTopic("disable");
      firebaseMessaging.unsubscribeFromTopic("general");
    }
    return Future.value();
  }

  Future<dynamic> processMessage(Map<String, dynamic> map) async {
    print("received message:");
    print(map);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(map['notification']['title']),
          subtitle: Text(map['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    final SharedPreferences prefs = await _prefs;
    var currentUser = await FirebaseAuth.instance.signInAnonymously();
    if (prefs.containsKey("userId")) {
      var userId = prefs.getString("userId");
      if (userId != currentUser.user.uid) {
        print("uid changed.");
      }
      setupDatabaseInstance(currentUser.user.uid);
      await _saveDeviceToken(currentUser.user.uid);
    } else {
      prefs.setString("userId", currentUser.user.uid);
      setupDatabaseInstance(currentUser.user.uid);
      await _saveDeviceToken(currentUser.user.uid);
    }

    return Future.value();
  }

  _saveDeviceToken(String userId) async {
    try {
      // Get the token for this device
      String fcmToken = await firebaseMessaging.getToken();
      // Save it to Firestore
      if (fcmToken != null) {
        var tokens = Firestore.instance
            .collection('users')
            .document(userId)
            .collection('tokens')
            .document(fcmToken);

        await tokens.setData({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        }, merge: true);
      }
    } catch (e) {
      return Future.value();
    }
  }

  Future<dynamic> processLaunch(Map<String, dynamic> map) async {
    print("processing launch");
    print(map);
  }

  Future<dynamic> processResume(Map<String, dynamic> map) async {
    print("processing resume");
    print(map);
  }
}
