import 'package:cst2335_group_project/flight.dart';
import 'package:floor/floor.dart';

/// Data Access Object (DAO) for the [Flight] entity.
@dao
abstract class FlightDao {
  /// Inserts a new [Flight] into the database.
  @insert
  Future<int> insertFlight(Flight flight);

  /// Finds all flights in the database.
  @Query('SELECT * FROM Flight')
  Future<List<Flight>> findAllFlights();

  /// Finds a flight by its [id].
  @Query('SELECT * FROM Flight WHERE id = :id')
  Future<Flight?> findFlightById(int id);

  /// Updates an existing [Flight] in the database.
  @update
  Future<int> updateFlight(Flight flight);

  /// Deletes a [Flight] from the database.
  @delete
  Future<int?> deleteFlight(Flight flight);
}
