import 'package:cst2335_group_project/utils.dart';
import 'package:floor/floor.dart';

@entity
class Airplane {
  @primaryKey
  final int id;
  String airplaneType;
  int maxPassengers;
  double maxSpeed;
  double maxRange;

  Airplane(this.id, this.airplaneType, this.maxPassengers, this.maxSpeed, this.maxRange) {
    if(id >= Utils.id) {
      Utils.id = id + 1;
    }
  }
}