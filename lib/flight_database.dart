import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:cst2335_group_project/flight.dart';
import 'package:cst2335_group_project/flight_dao.dart';

part 'flight_database.g.dart';

/// The main database class for the application.
///
/// This class represents the database and provides access to the [FlightDao].
@Database(version: 1, entities: [Flight])
abstract class AppDatabase extends FloorDatabase {
  /// Provides access to the [FlightDao] for interacting with flight data.
  FlightDao get flightDao;
}
