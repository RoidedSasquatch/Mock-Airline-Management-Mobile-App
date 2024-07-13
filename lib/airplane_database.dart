import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:cst2335_group_project/airplane.dart';
import 'package:cst2335_group_project/airplane_dao.dart';

part "airplane_database.g.dart";

@Database(version: 1, entities: [Airplane])
abstract class AppDatabase extends FloorDatabase {
  AirplaneDao get airplaneDao;
}