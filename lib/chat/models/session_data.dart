import 'dart:io';

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import 'package:logging/logging.dart';

part 'session_data.g.dart';

Logger _log = Logger('session_data.dart');

@HiveType(typeId: 10)
class SessionData extends ChangeNotifier with HiveObjectMixin {
  static const String hiveBoxName = 'session-box';
  static const String dataKey = 'data';

  bool _isReady = false;
  bool get isReady => _isReady;
  set isReady(bool ready) {
    _isReady = ready;
    notifyListeners();
  }

  @HiveField(0, defaultValue: null)
  String? _cookie;
  Cookie? get cookie => _cookie == null ? null : Cookie.fromSetCookieValue(_cookie!);
  set cookie(Cookie? actualCookie) {
    _cookie = actualCookie?.toString();
    notifyListeners();

    save();
  }

  SessionData();

  static Future<SessionData> loadData() async {
    Box box = await Hive.openBox(hiveBoxName);
    SessionData? result = box.get(dataKey);
    _log.finest('Data from DB ($hiveBoxName, $dataKey): $result');

    if (result == null) {
      result = SessionData();
      box.put(dataKey, result);
    }

    return result;
  }

  @override
  String toString() {
    return '{cookie: $_cookie,}';
  }
}