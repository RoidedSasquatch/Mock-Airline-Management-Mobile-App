import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class AirplaneDataRepository {
  static String airplaneType = "";
  static String maxPassengers = "";
  static String maxSpeed = "";
  static String maxRange = "";
  static EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

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

  static void saveData() {
    prefs.setString("type", airplaneType);
    prefs.setString("passengers", maxPassengers);
    prefs.setString("speed", maxSpeed);
    prefs.setString("range", maxRange);
  }
}