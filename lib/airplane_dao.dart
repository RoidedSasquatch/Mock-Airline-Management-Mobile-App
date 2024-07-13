import 'package:cst2335_group_project/airplane.dart';
import 'package:floor/floor.dart';

@dao
abstract class AirplaneDao {
  @insert
  Future<int> insertList(Airplane airplane);

  @Query('SELECT * FROM Airplane')
  Future<List<Airplane>> findAllListItems();

  @Query('SELECT FROM Airplane WHERE id = :id')
  Future<Airplane?> findSingleListItem(int id);

  @update
  Future<int> updateList(Airplane airplane);

  // @Query('UPDATE Airplane SET airplaneType = :airplaneType, maxPassengers = :maxPassengers, maxSpeed = :maxSpeed, maxRange = :maxRange WHERE id = :id')
  // Future<int> updateList(int id, String airplaneType, int maxPassengers, double maxSpeed, double maxRange);

  @Query('DELETE FROM Airplane WHERE id = :id')
  Future<int?> delete(int id);
}