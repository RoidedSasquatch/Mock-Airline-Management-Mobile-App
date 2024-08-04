// required package imports
import 'dart:async';
import 'package:cst2335_group_project/CustomerDAO.dart';
import 'package:cst2335_group_project/CustomerItem.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'AppDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [CustomerItem])
abstract class AppDatabase extends FloorDatabase {
  CustomerDAO get CustomerDao;
}