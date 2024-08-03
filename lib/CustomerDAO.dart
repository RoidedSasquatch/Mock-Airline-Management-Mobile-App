import 'package:cst2335_group_project/CustomerItem.dart';
import 'package:floor/floor.dart';

@dao
abstract class CustomerDAO {
  @Query('SELECT * FROM CustomerItem')
  Future<List<CustomerItem>> findAllToDoItems();

  @Query('DELETE FROM CustomerItem WHERE id = :id')
  Future<int?> deleteToDoItem(int id);

  @insert
  Future<int> insertCustomerItem(CustomerItem customerItem);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateCustomerItem(CustomerItem customerItem);
}
