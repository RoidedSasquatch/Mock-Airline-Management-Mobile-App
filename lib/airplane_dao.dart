import 'package:cst2335_group_project/airplane.dart';
import 'package:floor/floor.dart';

/// Data Access Object (DAO) for managing airplane data in a database.
@dao
abstract class AirplaneDao {
  /// Inserts a new airplane into the database.
  /// Returns the row ID of the inserted airplane.
  @insert
  Future<int> insertList(Airplane airplane);

  /// Retrieves all airplanes from the database.
  /// Returns a list of all airplanes stored in the database.
  @Query('SELECT * FROM Airplane')
  Future<List<Airplane>> findAllListItems();

  /// Retrieves a single airplane from the database based on its ID.
  /// Returns the airplane with the specified [id], or null if not found.
  @Query('SELECT FROM Airplane WHERE id = :id')
  Future<Airplane?> findSingleListItem(int id);

  /// Updates an existing airplane in the database.
  /// Returns the number of rows affected by the update operation.
  @update
  Future<int> updateList(Airplane airplane);

  /// Deletes an airplane from the database based on its ID.
  /// Returns the number of rows affected by the delete operation.
  @Query('DELETE FROM Airplane WHERE id = :id')
  Future<int?> delete(int id);
}