import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:last_earthquake_flutter/services/auth.dart';
import 'package:last_earthquake_flutter/services/database.dart';

GetIt instance = GetIt.instance;

void setupDatabaseInstance(String uid) {
  instance.registerLazySingleton(() => Database(userId: uid));
}

void setupAuthInstance(BuildContext context, FirebaseMessaging msg) {
  instance.registerLazySingleton(
      () => Auth(context: context, firebaseMessaging: msg));
}
