import 'package:floor/floor.dart';

@entity
class Flight {

  @PrimaryKey(autoGenerate: true)
  int? id;

  String destination;

  String origin;

  String departure;

  String arrival;

  Flight(this.destination, this.origin, this.departure, this.arrival);

}