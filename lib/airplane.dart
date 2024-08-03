import 'package:cst2335_group_project/utils.dart';
import 'package:floor/floor.dart';

/// Represents an airplane with various attributes.
@entity
class Airplane {

  /// Unique identifier for the airplane.
  @primaryKey
  final int id;

  /// Type of the airplane.
  String airplaneType;

  /// Maximum number of passengers the airplane can carry.
  int maxPassengers;

  /// Maximum speed of the airplane.
  double maxSpeed;

  /// Maximum range of the airplane.
  double maxRange;

  /// Constructs an instance of [Airplane] with the given attributes.
  Airplane(this.id, this.airplaneType, this.maxPassengers, this.maxSpeed, this.maxRange) {
    if(id >= Utils.id) {
      Utils.id = id + 1;
    }
  }
}