import 'package:cst2335_group_project/flight.dart';
import 'package:floor/floor.dart';

@dao
abstract class FlightDao {

  @insert
  Future<int> insertFlight(Flight flight);

  @Query('SELECT * FROM Flight')
  Future<List<Flight>> findAllFlights();

  @Query('SELECT * FROM Flight WHERE id = :id')
  Future<Flight?> findFlightById(int id);

  @update
  Future<int> updateFlight(Flight flight);

  @delete
  Future<int?> deleteFlight(Flight flight);

}