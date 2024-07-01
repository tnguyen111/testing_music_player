import 'dart:async';
import '../database/database.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class Injection {
  static final DatabaseHelper _databaseHelper = DatabaseHelper();
  static late Injector injector;
  static Future initInjection() async {
    await _databaseHelper.initDb();
    injector = Injector();
    injector.map<DatabaseHelper>((i) => _databaseHelper,
        isSingleton: true);
  }
}