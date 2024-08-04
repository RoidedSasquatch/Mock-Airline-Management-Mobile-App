import 'package:cst2335_group_project/flight_utils.dart';
import 'package:floor/floor.dart';

/// Represents a flight entity in the database.
@entity
class Flight {
  /// The primary key of the flight.
  @primaryKey
  int id;

  /// The origin location of the flight.
  String origin;

  /// The destination location of the flight.
  String destination;

  /// The departure time of the flight.
  String departure;

  /// The arrival time of the flight.
  String arrival;

  /// Creates a new [Flight] instance with the given [id], [origin], [destination], [departure], and [arrival].
  ///
  /// If the given [id] is greater than or equal to the current [FlightUtils.id], updates [FlightUtils.id].
  /// @param id The id of the [Flight].
  /// @param origin The origin of the [Flight].
  /// @param destination The destination of the [Flight].
  /// @param departure The departure time of the [Flight].
  /// @param arrival The arrival time of the [Flight].
  Flight(this.id, this.origin, this.destination, this.departure, this.arrival) {
    if (id >= FlightUtils.id) {
      FlightUtils.id = id + 1;
    }
  }
}
