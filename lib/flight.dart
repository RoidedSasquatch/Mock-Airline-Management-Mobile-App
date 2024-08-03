import 'package:cst2335_group_project/flight_utils.dart';
import 'package:floor/floor.dart';

@entity
class Flight {

  @primaryKey
  int id;

  String origin;

  String destination;

  String departure;

  String arrival;

  Flight(this.id, this.origin, this.destination, this.departure, this.arrival) {
    if(id >= FlightUtils.id) {
      FlightUtils.id = id + 1;
    }
  }

}