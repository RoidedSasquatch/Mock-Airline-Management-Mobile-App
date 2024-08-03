import 'package:floor/floor.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Entity(tableName: 'CustomerItem')
class CustomerItem {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String firstName;
  final String lastName;
  final int passportNumber;
  final int budget;

  static int _cusID = 1;
  static SharedPreferences? _prefs;

  CustomerItem(this.id, this.firstName, this.lastName, this.passportNumber, this.budget) {
    if (id >= _cusID) {
      _cusID = id + 1;
      saveCusID();
    }
  }

  static Future<void> initializeCusID() async {
    _prefs = await SharedPreferences.getInstance();
    _cusID = _prefs?.getInt('cusID') ?? 0;
  }

  static Future<void> saveCusID() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    await _prefs?.setInt('cusID', _cusID);
  }

  static int get cusID => _cusID;
  static set cusID(int value) {
    _cusID = value;
    saveCusID();
  }
}
