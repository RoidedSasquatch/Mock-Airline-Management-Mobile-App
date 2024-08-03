import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// A repository class for managing airplane data using encrypted shared preferences.
class AirplaneDataRepository {

  /// The current airplane type being managed.
  static String airplaneType = "";

  /// The maximum number of passengers for the current airplane type.
  static String maxPassengers = "";

  /// The maximum speed of the current airplane type.
  static String maxSpeed = "";

  /// The maximum range of the current airplane type.
  static String maxRange = "";

  /// Shared preferences instance for storing encrypted data.
  static EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  /// Loads airplane data from encrypted shared preferences.
  /// Retrieves stored values for [airplaneType], [maxPassengers], [maxSpeed],
  /// and [maxRange] from encrypted storage and updates respective static variables.
  static void loadData() {
    prefs.getString("type").then((value) {
      airplaneType = value;
    });
    prefs.getString("passengers").then((value) {
      maxPassengers = value;
    });
    prefs.getString("speed").then((value) {
      maxSpeed = value;
    });
    prefs.getString("range").then((value) {
      maxRange = value;
    });
  }

  /// Saves current airplane data to encrypted shared preferences.
  /// Stores the current values of [airplaneType], [maxPassengers], [maxSpeed],
  /// and [maxRange] into encrypted storage for future retrieval.
  static void saveData() {
    prefs.setString("type", airplaneType);
    prefs.setString("passengers", maxPassengers);
    prefs.setString("speed", maxSpeed);
    prefs.setString("range", maxRange);
  }
}